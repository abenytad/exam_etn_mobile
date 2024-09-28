
class MaterialModel {
  final String id;
  final String name;
  final String description;
  final String materialUrl;
  final String type;
  final String courseId;
  final int occurence;
  MaterialModel({
    required this.id,
    required this.name,
    required this.description,
    required this.materialUrl,
    required this.type,
    required this.courseId,
    required this.occurence,
  });
 MaterialModel.fromApi(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        description = parsedJson['description'] ?? '',
        materialUrl = parsedJson['materialUrl'] ?? '',
        type = parsedJson['type'] ?? '',
        courseId = parsedJson['courseId'] ?? '',
        occurence = parsedJson['occurence'] ?? 0;
}