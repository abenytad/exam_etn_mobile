import 'package:flutter/material.dart';
import 'programs_bloc.dart';

class ProgramsProvider extends InheritedWidget {
  final ProgramsBloc bloc;

  ProgramsProvider({Key? key, required Widget child})
      : bloc = ProgramsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ProgramsBloc of(BuildContext context) {
    final ProgramsProvider? provider = context.dependOnInheritedWidgetOfExactType<ProgramsProvider>();
    if (provider == null) {
      throw FlutterError('ProgramsProvider.of() called with a context that does not contain a ProgramsProvider.');
    }
    return provider.bloc;
  }
}
