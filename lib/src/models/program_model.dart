
class ProgramModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int totalCourses;
  final int totalMocks;
  final int totlaModels;
  final List<int> nationalExams;
  final double price;
  final bool enrolled;


  ProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.totalCourses,
    required this.totalMocks,
    required this.totlaModels,
    required this.nationalExams,
    required this.price,
     required this.enrolled,
  });

  // Constructor to create an instance from full API response
  ProgramModel.fromApi(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        description = parsedJson['description'] ?? '',
        imageUrl = parsedJson['imageUrl'] ?? '',
        totalCourses = parsedJson['totalCourses'] ?? 0,
        totalMocks = parsedJson['totalMocks'] ?? 0,
        totlaModels = parsedJson['totlaModels'] ?? 0,
        nationalExams = List<int>.from(parsedJson['nationalExams'] ?? []),
        price = parsedJson['price']?.toDouble() ?? 0.0,
        enrolled = parsedJson['enrolled'] ?? false;

  // Constructor to create an instance from partial API response
  ProgramModel.fromApiPartial(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        description = '', // Default or placeholder value
        imageUrl = parsedJson['imageUrl'] ?? '',
        totalCourses = 0, // Default or placeholder value
        totalMocks = 0, // Default or placeholder value
        totlaModels = 0, // Default or placeholder value
        nationalExams = [], 
        enrolled = parsedJson['enrolled'] ?? false,// Default or placeholder value
        price = 0.0;
        // Default or placeholder value
// constructor for the enrolled program
    ProgramModel.fromApiEnrolled(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        name = parsedJson['name'] ?? '',
        description = '', // Default or placeholder value
        imageUrl = parsedJson['imageUrl'] ?? '',
        totalCourses = 0, // Default or placeholder value
        totalMocks = 0, // Default or placeholder value
        totlaModels = 0, // Default or placeholder value
        nationalExams = [],
        enrolled=true, // Default or placeholder value
        price = 0.0; // Default or placeholder value
}
