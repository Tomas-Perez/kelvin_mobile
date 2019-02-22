import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/auth_service.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthAction, AuthState> {
  final AuthService _authService;
  final ApiConnectionBloc _connectionBloc;

  AuthBloc(this._authService, this._connectionBloc);

  void login(LoginInfo loginInfo) => dispatch(Login(loginInfo));

  void logout() => dispatch(Logout());

  void _loginRequest(LoginInfo loginInfo) async {
    try {
      final token = await _authService.login(
        loginInfo,
        url: _connectionBloc.currentState.url,
      );
      dispatch(LoginResponse(token));
    } catch (e) {
      print(e);
      dispatch(LoginError(e));
    }
  }

  void _getUserData() async {
    try {
      final userData = await _authService.getUserData(
        currentState.token,
        url: _connectionBloc.currentState.url,
      );
      if (userData.userType == UserType.admin) {
        dispatch(Authorized());
      } else {
        dispatch(LoginError(AuthErrors.notAdmin));
      }
    } catch (e) {
      print(e);
      dispatch(LoginError(e));
    }
  }

  void _checkConnection(void then()) async {
    try {
      final connectionState =
          await _connectionBloc.state.firstWhere((state) => !state.loading);
      if (connectionState.connected) {
        then();
      } else {
        dispatch(LoginError(AuthErrors.noConnection));
      }
    } catch (e) {
      print(e);
      dispatch(LoginError(e));
    }
  }

  @override
  AuthState get initialState => AuthState.initial();

  @override
  Stream<AuthState> mapEventToState(
    AuthState currentState,
    AuthAction event,
  ) async* {
    if (event is Login) {
      yield currentState.setLoading();
      _checkConnection(() => _loginRequest(event.loginData));
    } else if (event is LoginError) {
      yield currentState.setError(event.message);
    } else if (event is LoginResponse) {
      yield currentState.setToken(event.token);
      _checkConnection(_getUserData);
    } else if (event is Authorized) {
      yield currentState.setAuthorized();
    } else if (event is Logout) {
      yield AuthState.initial();
    } else {
      yield currentState;
    }
  }
}

abstract class AuthAction {
  const AuthAction();
}

class Login extends AuthAction {
  final LoginInfo loginData;

  Login(this.loginData);
}

class LoginError extends AuthAction {
  final String message;

  LoginError(this.message);
}

class LoginResponse extends AuthAction {
  final String token;

  LoginResponse(this.token);
}

class Authorized extends AuthAction {
  const Authorized();
}

class Logout extends AuthAction {
  const Logout();
}

@immutable
class AuthState {
  final String token;
  final bool loading;
  final bool authorized;
  final bool hasError;
  final String errorMessage;

  static final _initialState = AuthState._();

  AuthState._({
    this.token,
    this.loading = false,
    this.authorized = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory AuthState.initial() => _initialState;

  AuthState setLoading() {
    return AuthState._(loading: true);
  }

  AuthState setAuthorized() {
    return AuthState._(token: token, authorized: true);
  }

  AuthState setToken(String token) {
    return AuthState._(token: token, loading: true);
  }

  AuthState setError(String message) {
    return AuthState._(
      hasError: true,
      errorMessage: message,
    );
  }
}

class AuthErrors {
  AuthErrors._();

  static const noConnection = 'NO_CONNECTION';
  static const notAdmin = 'NOT_ADMIN';
  static const unauthorized = 'UNATHORIZED';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class NoConnectionException implements AuthException {
  final String message = AuthErrors.noConnection;

  const NoConnectionException();
}

class NotAdminException implements AuthException {
  final String message = AuthErrors.notAdmin;

  const NotAdminException();
}

class UnauthorizedException implements AuthException {
  final String message = AuthErrors.unauthorized;

  const UnauthorizedException();
}
