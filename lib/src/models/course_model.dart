class CourseModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String programId;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.programId,
  });

  CourseModel.fromApi(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        description = parsedJson['description'] ?? '',
        imageUrl = parsedJson['imageUrl'] ?? '',
        programId = parsedJson['programId'] ?? '';
}


