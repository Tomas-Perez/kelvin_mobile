import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';

class AuthGuard extends StatelessWidget {
  final Widget login;
  final Widget homeScreen;

  AuthGuard({@required this.login, @required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthAction, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (context, state) {
        return AnimatedCrossFade(
          firstChild: login,
          secondChild: homeScreen,
          crossFadeState: !state.authorized
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
          layoutBuilder: layoutBuilder,
        );
      },
    );
  }

  Widget layoutBuilder(Widget topChild, Key topChildKey, Widget bottomChild,
      Key bottomChildKey) {
    return Stack(
      children: <Widget>[
        Positioned(
          key: bottomChildKey,
          child: bottomChild,
        ),
        Positioned(
          key: topChildKey,
          child: topChild,
        ),
      ],
    );
  }
}
