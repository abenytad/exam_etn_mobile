class UserModel {
  final String id;
  final String name;
  final int phoneNumber;
  final List<String> enrolledPrograms;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.enrolledPrograms,
  });

  UserModel.fromApi(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        phoneNumber = parsedJson['phoneNumber'] ?? 0,
        enrolledPrograms = (parsedJson['enrolledPrograms'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ?? [];
}
