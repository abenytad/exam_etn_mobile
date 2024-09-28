import 'dart:async';
import 'package:pics/src/models/material_model.dart';
import 'package:rxdart/rxdart.dart';
import '../models/program_model.dart';
import '../resources/program_api.dart';
import '../models/course_model.dart';
import '../models/bank_model.dart';
import '../services/shared_data.dart';
class ProgramsBloc {
  final _apiProvider = ProgramsApiProvider();
  final _programIds = PublishSubject<List<String>>();
  final _enrolledPrograms = PublishSubject<List<ProgramModel>>();
  final _courses = PublishSubject<List<CourseModel>>();
  final _materials = PublishSubject<List<MaterialModel>>();
  final _programDetails = PublishSubject<ProgramModel>();
  final _banks = PublishSubject<List<BankModel>>();
  final _itemOutput = BehaviorSubject<Map<String, Future<ProgramModel>>>();
  final _enrolled = BehaviorSubject<bool>.seeded(false);
  final _itemFetcher = PublishSubject<String>();
  Stream<List<String>> get getTopIds => _programIds.stream;
  Stream<List<ProgramModel>> get getEnrolledPrograms => _enrolledPrograms.stream;
  Stream<List<CourseModel>> get getCourses => _courses.stream;
  Stream<List<BankModel>> get getBanks => _banks.stream;
  Stream<List<MaterialModel>> get getMaterials => _materials.stream;
   Stream<bool> get getEnrolled => _enrolled.stream;
  Stream<ProgramModel> get getProgramDetails => _programDetails.stream;
  Stream<Map<String, Future<ProgramModel>>> get programs => _itemOutput.stream;
  Function(String) get fetchProgram => _itemFetcher.sink.add;
  ProgramsBloc() {
    _itemFetcher.stream.transform(_itemTransformer()).pipe(_itemOutput);
  }
  Future<String?> _getUserId() async {
    final userData = await PreferencesService.getUserData();
    return userData['_id'] as String?;
  }

  StreamTransformer<String, Map<String, Future<ProgramModel>>> _itemTransformer() {
    return ScanStreamTransformer((Map<String, Future<ProgramModel>> cache, String id, int index) {
      cache[id] = _apiProvider.fetchProgramTitle(id);
      return cache;
    }, <String, Future<ProgramModel>>{});
  }
  Future<void> fetchTopIds() async {
    final ids = await _apiProvider.fetchProgramIds();
    _programIds.sink.add(ids);
  }
  Future<void> fetchProgramDetails(String id) async {
    final data = await _apiProvider.fetchProgramDetail(id);
    _programDetails.sink.add(data);
  }

  Future<void> enrollProgram(String programId) async {
    final userId = await _getUserId();
    if (userId != null) {
      await _apiProvider.enrollProgram(userId, programId);
    } else {
      throw Exception('User ID not found');
    }
  }
  Future<void> enrolledPrograms() async {
    final userId = await _getUserId();
    if (userId != null) {
      final programs = await _apiProvider.fetchEnrolledPrograms(userId);
      _enrolledPrograms.sink.add(programs);
    } else {
      throw Exception('User ID not found');
    }
  }
  Future<void> fetchCourses(String programId) async {
    final courses = await _apiProvider.fetchCourses(programId);
    _courses.sink.add(courses);
  }
    Future<void> fetchBanks() async {
    final banks = await _apiProvider.fetchBanks();
    _banks.sink.add(banks);
  }
  Future<void> fetchMaterials(String courseId) async {
    final materials = await _apiProvider.fetchMaterials(courseId);
    _materials.sink.add(materials);
  }
  setEnrolled(){
    _enrolled.sink.add(true);
  }
   setEnrolledFalse(){
    _enrolled.sink.add(false);
  }
  void dispose() {
    _programDetails.close();
    _programIds.close();
    _itemOutput.close();
    _itemFetcher.close();
    _enrolledPrograms.close();
    _courses.close();
    _materials.close();
    _banks.close();
  }
}
