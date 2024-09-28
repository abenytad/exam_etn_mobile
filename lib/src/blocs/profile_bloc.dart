import 'package:pics/src/mixins/validator_mixin.dart';
import 'package:pics/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import '../services/shared_data.dart';
import 'package:pics/src/resources/program_api.dart';

class ProfileBloc extends Object with ValidatorMixin {
  final _apiProvider = ProgramsApiProvider();
  final _phoneNumber = BehaviorSubject<int>();
  final _fullName = BehaviorSubject<String>();
  final _user = BehaviorSubject<UserModel>();
  final _newPassword = BehaviorSubject<String>.seeded('');
  final _oldPassword = BehaviorSubject<String>.seeded('');
  final _confirmPassword = BehaviorSubject<String>.seeded('');
  final _isLoading = BehaviorSubject<bool>.seeded(false);
  final _successMessage = BehaviorSubject<String>();
  final _errorMessage = BehaviorSubject<String>();

  Stream<UserModel?> get getUser => _user.stream;
  Stream<int> get getPhoneNumber => _phoneNumber.stream.transform(phoneNumberValidator);
  Stream<String> get getFullName => _fullName.stream.transform(nameValidator);
  Stream<bool> get isLoading => _isLoading.stream;
  Stream<String> get successMessage => _successMessage.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<String> get getNewPassword => _newPassword.stream.transform(passwordValidator);
  Stream<String> get getOldPassword => _oldPassword.stream.transform(passwordValidator);
  Stream<String> get getConfirmPassword => _confirmPassword.stream.transform(passwordValidator);

  Function(int) get changePhoneNumber => _phoneNumber.sink.add;
  Function(String) get changeName => _fullName.sink.add;
  Function(String) get changeNewPassword => _newPassword.sink.add;
  Function(String) get changeOldPassword => _oldPassword.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  Future<String?> _getUserId() async {
    final userData = await PreferencesService.getUserData();
    return userData['_id'] as String?;
  }

  Future<void> updateProfile() async {
    _isLoading.add(true);
    _successMessage.add('');
    _errorMessage.add('');
    final userId = await _getUserId();

    if (userId == null) {
      _isLoading.add(false);
      _errorMessage.add('User ID is null. Unable to update profile.');
      throw Exception('User ID is null. Unable to update profile.');
    }

    try {
      await _apiProvider.updateUserDetails(userId, _fullName.value, _phoneNumber.value);
      _successMessage.add('Profile updated successfully!');
    } catch (e) {
      _errorMessage.add('Failed to update profile: $e');
      rethrow;
    } finally {
      _isLoading.add(false);
    }
  }

  Future<void> updatePassword() async {
    _isLoading.add(true);
    _successMessage.add('');
    _errorMessage.add('');
    final userId = await _getUserId();

    if (userId == null) {
      _isLoading.add(false);
      _errorMessage.add('User ID is null. Unable to update password.');
      throw Exception('User ID is null. Unable to update password.');
    }

    try {
      await _apiProvider.changePassword(userId, _oldPassword.value, _newPassword.value);
      _successMessage.add('Password updated successfully!');
    } catch (e) {
      _errorMessage.add('Failed to update password: $e');
      rethrow;
    } finally {
      _isLoading.add(false);
    }
  }

  Stream<bool> get isValidPasswordInput => Rx.combineLatest3(
    _oldPassword.stream,
    _newPassword.stream,
    _confirmPassword.stream,
    (oldPass, newPass, confirmPass) {
      return newPass == confirmPass && oldPass.isNotEmpty && newPass.isNotEmpty;
    },
  );

  void dispose() {
    _phoneNumber.close();
    _fullName.close();
    _user.close();
    _isLoading.close();
    _newPassword.close();
    _oldPassword.close();
    _confirmPassword.close();
    _successMessage.close();
    _errorMessage.close();
  }
}
