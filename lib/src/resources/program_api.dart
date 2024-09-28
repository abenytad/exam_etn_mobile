import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pics/src/models/exam_model.dart';
import 'package:pics/src/models/question_model.dart';
import '../models/program_model.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/material_model.dart';
import '../services/shared_data.dart';
import '../models/bank_model.dart';
class ProgramsApiProvider {
  final String ipaddres = '10.154.35.15';

  // Helper function to get the JWT token
  Future<String?> _getToken() async {
    return await PreferencesService.getToken();
  }

  Future<String?> _getUserId() async {
    final userData = await PreferencesService.getUserData();
    return userData['_id'] as String?;
  }

  Future<ProgramModel> fetchProgramTitle(String id) async {
    final userId = await _getUserId();
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/title/$id/$userId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return ProgramModel.fromApiPartial(json.decode(response.body));
    } else {
      throw Exception('Failed to load program title');
    }
  }

  Future<ProgramModel> fetchProgramDetail(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/details/$id'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return ProgramModel.fromApi(json.decode(response.body));
    } else {
      throw Exception('Failed to load program title');
    }
  }

  Future<List<String>> fetchProgramIds() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/ids'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<String> programIds = List<String>.from(data);
      return programIds;
    } else {
      throw Exception('Failed to load program ids');
    }
  }

  Future<void> enrollProgram(String userId, String programId) async {
    final token = await _getToken();
    final url = Uri.parse('http://$ipaddres:5000/users/enroll/$userId');
    final body = jsonEncode({
      'programId': programId,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to enroll in the program');
    }
  }

  Future<List<ProgramModel>> fetchEnrolledPrograms(String userId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/enrolled/$userId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<ProgramModel> programs = data.map((programData) {
        return ProgramModel.fromApiPartial(programData);
      }).toList();
      print(programs);
      return programs;
    } else {
      throw Exception('Failed to load enrolled programs');
    }
  }

  Future<List<CourseModel>> fetchCourses(String programId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/courses/$programId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<CourseModel> courses = data.map((courseData) {
        return CourseModel.fromApi(courseData);
      }).toList();

      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<MaterialModel>> fetchMaterials(String courseId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/programs/materials/$courseId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<MaterialModel> materials = data.map((materialData) {
        return MaterialModel.fromApi(materialData);
      }).toList();

      return materials;
    } else {
      throw Exception('Failed to load materials');
    }
  }

  Future<ExamModel> fetchExam(String userId, String programId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/exams/questions/$programId/$userId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return ExamModel.fromApi(json.decode(response.body));
    } else {
      throw Exception('Failed to load exam');
    }
  }

  Future<QuestionModel> fetchQuestion(String examId, String questionId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/exams/question/$examId/$questionId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return QuestionModel.fromApi(json.decode(response.body));
    } else {
      throw Exception('Failed to load question');
    }
  }

  Future<void> giveAnswer(String examId, String questionId, int answer) async {
    final token = await _getToken();
    final url = Uri.parse('http://$ipaddres:5000/exams/answer');
    final body = jsonEncode({
      'examId': examId,
      'questionId': questionId,
      'answer': answer,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit answer');
    }
  }

  Future<int> fetchResult(String examId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/exams/result/$examId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load result');
    }
  }

  Future<void> updateUserDetails(
      String userId, String name, int phoneNumber) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('http://$ipaddres:5000/users/profile/$userId'),
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            }
          : {
              'Content-Type': 'application/json',
            },
      body: json.encode({
        'name': name,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      await PreferencesService.saveUserData(userData);
    } else {
      throw Exception('Failed to update user details');
    }
  }

  Future<void> changePassword(
      String userId, String oldPassword, String newPassword) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('http://$ipaddres:5000/users/password/$userId'),
      headers: token != null
          ? {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            }
          : {
              'Content-Type': 'application/json',
            },
      body: json.encode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user details');
    }
  }
  Future<String> fetchAIResponse(String question) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('http://$ipaddres:5000/programs/request'), //
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'data': question}), 
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load AI response: ${response.reasonPhrase}');
    }
  }

  Future<List<QuestionModel>> fetchQuestions(String examId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
          'http://$ipaddres:5000/exams/all/$examId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<QuestionModel> questions = jsonData
          .map((data) => QuestionModel.fromApi(data as Map<String, dynamic>))
          .toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }
   Future<List<BankModel>> fetchBanks() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/banks/'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<BankModel> banks = data.map((bankData) {
        final bank=BankModel.fromApi(bankData);
        print(bank.imageUrl);
        return bank;
      
      }).toList();
      return banks;
    } else {
      throw Exception('Failed to load enrolled programs');
    }
  }
    Future<BankModel> fetchBank(String bankId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('http://$ipaddres:5000/exams/banks/$bankId'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (response.statusCode == 200) {
      return BankModel.fromApi(json.decode(response.body));
    } else {
      throw Exception('Failed to load question');
    }
  }
}
