class QuestionModel {
  final String id;
  final String userId;
  final String question;
  final String programId;
  final String type;
  final int answer;
  final List<String> options;
  final int givenAnswer;
  final String description;
  QuestionModel({
    required this.id,
    required this.userId,
    required this.programId,
    required this.options,
    required this.question,
    required this.type,
    required this.answer,
    required this.description,
    required this.givenAnswer,
  });

  factory QuestionModel.fromApi(Map<String, dynamic> parsedJson) {
    var optionsFromJson = parsedJson['options'] as List<dynamic>;
    List<String> optionsList = optionsFromJson.map((item) => item as String).toList();

    return QuestionModel(
      id: parsedJson['_id'] ?? '',
      userId: parsedJson['userId'] ?? '',
      programId: parsedJson['programId'] ?? '',
      question: parsedJson['question'] ?? '',
      type: parsedJson['type'] ?? '',
      answer: parsedJson['answer'] ?? 0,
      options: optionsList,
      description: parsedJson['description'] ?? '',
      givenAnswer: parsedJson['givenAnswer'] ?? 0,
    );
  }
}
