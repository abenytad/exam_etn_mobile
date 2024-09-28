import 'dart:async';

mixin ValidatorMixin {
  final phoneNumberValidator = StreamTransformer<int, int>.fromHandlers(
  handleData: (data, sink) {
    final phoneNumberString = data.toString();
    if (phoneNumberString.length != 9 || 
        !(phoneNumberString.startsWith('9') || phoneNumberString.startsWith('7'))) {
      sink.addError('Invalid Phone Number');
    } else {
      sink.add(data);
    }
  }
);


  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (data.length < 8) {
        sink.addError('Password must be at least 8 characters');
      } else {
        sink.add(data);
      }
    }
  );

  final nameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (data.length < 6 || !data.contains(' ')) {
        sink.addError('Name must be at least 6 characters and contain a space');
      } else {
        sink.add(data);
      }
    }
  );
}
