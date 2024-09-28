import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:pics/src/resources/program_api.dart';

class ChatbotBloc {
  final _text = BehaviorSubject<String>();
  final _messages = BehaviorSubject<List<String>>.seeded([]);
  final _apiProvider = ProgramsApiProvider();
  
  final textValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (String value, EventSink<String> sink) {
      if (value.length < 2) {
        sink.addError('Please enter a valid message');
      } else {
        sink.add(value);
      }
    },
  );

  Stream<String> get getText => _text.stream.transform(textValidator);
  Function(String) get changeText => _text.sink.add;

  Stream<List<String>> get messagesStream => _messages.stream;

  void submit() async {
    final message = _text.value;
    if (message.isNotEmpty) {
      final updatedMessages = List<String>.from(_messages.value)..add(message);
      _messages.add(updatedMessages);
      _text.add('');  // Clear the text field
      
      try {
        final response = await _apiProvider.fetchAIResponse(message);
        if (response.isNotEmpty) {
          final responseMessage = 'AI Response: $response';
          final updatedMessagesWithResponse = List<String>.from(updatedMessages)..add(responseMessage);
          _messages.add(updatedMessagesWithResponse);
        }
      } catch (error) {
        print('Error fetching AI response: $error');
      }
    }
  }

  void dispose() {
    _text.close();
    _messages.close();
  }
}
