import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/services/connection_service.dart';
import 'package:meta/meta.dart';

class ApiConnectionBloc extends Bloc<ApiConnectionAction, ApiConnectionState> {
  final String initialUrl;
  final ApiConnectionService connectionService;

  ApiConnectionBloc({this.initialUrl, this.connectionService}) {
    _checkConnection();
  }

  @override
  ApiConnectionState get initialState =>
      ApiConnectionState.from(this.initialUrl);

  updateUrl(String url) => dispatch(UpdateConnection(url));

  checkConnection() => dispatch(UpdateConnection(currentState.url));

  _checkConnection() async {
    try {
      await connectionService.checkConnection(currentState.url);
      dispatch(Connected());
    } catch (e) {
      dispatch(Disconnected());
    }
  }

  @override
  Stream<ApiConnectionState> mapEventToState(
      ApiConnectionState currentState, ApiConnectionAction event) async* {
    if (event is Connected) {
      yield currentState.setConnected();
    } else if (event is Disconnected) {
      yield currentState.setDisconnected();
    } else if (event is UpdateConnection) {
      yield ApiConnectionState.from(event.url);
      _checkConnection();
    } else {
      yield currentState;
    }
  }
}

abstract class ApiConnectionAction {
  const ApiConnectionAction();
}

class UpdateConnection extends ApiConnectionAction {
  final url;

  UpdateConnection(this.url);
}

class Connected extends ApiConnectionAction {
  const Connected();
}

class Disconnected extends ApiConnectionAction {
  const Disconnected();
}

@immutable
class ApiConnectionState {
  final String url;
  final bool loading;
  final bool connected;

  ApiConnectionState._({
    this.url,
    this.loading = false,
    this.connected = false,
  });

  factory ApiConnectionState.from(String url) {
    return ApiConnectionState._(url: url, loading: true);
  }

  ApiConnectionState setConnected() {
    return ApiConnectionState._(url: this.url, connected: true);
  }

  ApiConnectionState setDisconnected() {
    return ApiConnectionState._(url: this.url);
  }
}
