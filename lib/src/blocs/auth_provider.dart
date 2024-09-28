import 'package:flutter/material.dart';
import 'auth_bloc.dart';

class AuthProvider extends InheritedWidget {
  final AuthBloc bloc;

  AuthProvider({Key? key, required Widget child})
      : bloc = AuthBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthBloc of(BuildContext context) {
    final AuthProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    if (provider == null) {
      throw FlutterError(
          'ExamProvider.of() called with a context that does not contain a ProgramsProvider.');
    }
    return provider.bloc;
  }
}
