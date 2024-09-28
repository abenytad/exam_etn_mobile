import 'package:flutter/material.dart';
import 'exam_bloc.dart';

class ExamProvider extends InheritedWidget {
  final ExamBloc bloc;

  ExamProvider({Key? key, required Widget child})
      : bloc = ExamBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ExamBloc of(BuildContext context) {
    final ExamProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ExamProvider>();
    if (provider == null) {
      throw FlutterError(
          'ExamProvider.of() called with a context that does not contain a ProgramsProvider.');
    }
    return provider.bloc;
  }
}
