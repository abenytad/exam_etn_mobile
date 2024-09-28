class ExamModel {
  final String id;
  final String userId;
  final String programId;
  final List<String> questionIds;

  ExamModel({
    required this.id,
    required this.userId,
    required this.programId,
    required this.questionIds,
  });

  factory ExamModel.fromApi(Map<String, dynamic> parsedJson) {
    var questionIdsFromJson = parsedJson['questionIds'] as List<dynamic>;
    List<String> questionIdsList = questionIdsFromJson.map((item) => item as String).toList();

    return ExamModel(
      id: parsedJson['_id'] ?? '',
      userId: parsedJson['userId'] ?? '',
      programId: parsedJson['programId'] ?? '',
      questionIds: questionIdsList,
    );
  }
}
