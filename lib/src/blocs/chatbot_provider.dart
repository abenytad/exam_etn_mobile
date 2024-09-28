import 'package:flutter/material.dart';
import 'chatbot_bloc.dart';

class ChatbotProvider extends InheritedWidget {
  final ChatbotBloc bloc;

  ChatbotProvider({Key? key, required Widget child})
      : bloc = ChatbotBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ChatbotBloc of(BuildContext context) {
    final ChatbotProvider? provider =
        context.dependOnInheritedWidgetOfExactType<ChatbotProvider>();
    if (provider == null) {
      throw FlutterError(
          'ExamProvider.of() called with a context that does not contain a ProgramsProvider.');
    }
    return provider.bloc;
  }
}
