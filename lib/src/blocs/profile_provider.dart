import 'package:flutter/material.dart';
import 'profile_bloc.dart';

class ProfileProvider extends InheritedWidget {
  final ProfileBloc bloc;

  ProfileProvider({Key? key, required Widget child})
      : bloc = ProfileBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ProfileBloc of(BuildContext context) {
    final ProfileProvider? provider = context.dependOnInheritedWidgetOfExactType<ProfileProvider>();
    if (provider == null) {
      throw FlutterError('ProgramsProvider.of() called with a context that does not contain a ProgramsProvider.');
    }
    return provider.bloc;
  }
}
