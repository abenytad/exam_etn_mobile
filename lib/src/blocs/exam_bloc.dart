import 'dart:async';
import 'package:pics/src/models/exam_model.dart';
import 'package:pics/src/models/question_model.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/program_api.dart';
import '../services/shared_data.dart'; // Import PreferencesService

class ExamBloc {
  final _apiProvider = ProgramsApiProvider();
  final _exam = PublishSubject<ExamModel>();
  final _question = PublishSubject<QuestionModel>();
  final _result = PublishSubject<int>();
  final _counter = BehaviorSubject<int>.seeded(0);
  final _questions = PublishSubject<List<QuestionModel>>();

  Stream<ExamModel> get getExam => _exam.stream;
  Stream<QuestionModel> get getQuestion => _question.stream;
  Stream<List<QuestionModel>> get getQuestions => _questions.stream;
  Stream<int> get getCounter => _counter.stream;
  Stream<int> get getResult => _result.stream;

  // Function to get userId from SharedPreferences
  Future<String?> _getUserId() async {
    final userData = await PreferencesService.getUserData();
    return userData['_id'] as String?;
  }

  Future<void> fetchExam(String programId) async {
    final userId = await _getUserId();
    if (userId != null) {
      final exam = await _apiProvider.fetchExam(userId, programId);
      _exam.sink.add(exam);
    } else {
      throw Exception('User ID not found');
    }
  }

  Future<void> fetchQuestion(String examId, String questionId) async {
    final question = await _apiProvider.fetchQuestion(examId, questionId);
    _question.sink.add(question);
  }

  Future<void> fetchQuestions(String examId) async {
    final questions = await _apiProvider.fetchQuestions(examId);
    _questions.sink.add(questions);
  }

  Future<void> fetchResult(String examId) async {
    final result = await _apiProvider.fetchResult(examId);
    _result.sink.add(result);
  }

  void incrementCounter() {
    final currentValue = _counter.value;
    _counter.sink.add(currentValue + 1); // Increment the counter
  }

  void decrementCounter() {
    final currentValue = _counter.value;
    _counter.sink.add(currentValue - 1); // Decrement the counter
  }

  Future<void> addAnswer(String examId, String questionId, int answer) async {
    await _apiProvider.giveAnswer(examId, questionId, answer);
  }

  void dispose() {
    _exam.close();
    _question.close();
    _counter.close();
  }
}
