import 'package:flutter/material.dart';
import 'package:pics/src/mixins/validator_mixin.dart';
import 'package:pics/src/models/user_model.dart';
import 'package:pics/src/resources/auth_api.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends Object with ValidatorMixin {
  final _authApiProvider = AuthApiProvider();
  final _phoneNumber = BehaviorSubject<int>.seeded(0); // Default value
  final _fullName = BehaviorSubject<String>.seeded(''); // Default value
  final _password = BehaviorSubject<String>.seeded(''); // Default value
  final _confirmPassword = BehaviorSubject<String>.seeded(''); // Default value
  final _user = BehaviorSubject<UserModel?>.seeded(null); // Nullable UserModel
  final _isLoading = BehaviorSubject<bool>.seeded(false); // Added loading state

  Stream<UserModel?> get getUser => _user.stream;
  Stream<int> get getPhoneNumber =>
      _phoneNumber.stream.transform(phoneNumberValidator);
  Stream<String> get getFullName => _fullName.stream.transform(nameValidator);
  Stream<String> get getPassword =>
      _password.stream.transform(passwordValidator);
  Stream<String> get getConfirmPassword =>
      _confirmPassword.stream.transform(passwordValidator);

  Stream<bool> getValidSignUpInput() => Rx.combineLatest4(
        getPhoneNumber,
        getFullName,
        getPassword,
        getConfirmPassword,
        (phoneNumber, fullName, password, confirmPassword) {
          // Check if password and confirmPassword are the same
          return password == confirmPassword;
        },
      );

  Stream<bool> getValidSignInInput() => Rx.combineLatest2(
        getPhoneNumber,
        getPassword,
        (phoneNumber, password) {
          // Check if password and confirmPassword are the same
          return true;
        },
      );

  Stream<bool> get isLoading => _isLoading.stream;

  Function(int) get changePhoneNumber => _phoneNumber.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeName => _fullName.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  Future<void> fetchUser() async {
    _isLoading.sink.add(true); // Start loading
    try {
      final user = await _authApiProvider.login(_phoneNumber.value, _password.value);
      _user.sink.add(user);
    } catch (e) {
      // Handle errors as needed
      rethrow;
    } finally {
      _isLoading.sink.add(false); // Stop loading
    }
  }

  Future<void> signupUser() async {
    _isLoading.sink.add(true); // Start loading
    try {
      await _authApiProvider.signUp(_phoneNumber.value, _password.value, _fullName.value);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading.sink.add(false); // Stop loading
    }
  }

  Future<void> logout() async {
    await _authApiProvider.logout();
    _phoneNumber.add(0); // Clear phone number field with default value
    _fullName.add(''); // Clear full name field with default value
    _password.add(''); // Clear password field with default value
    _confirmPassword.add(''); // Clear confirm password field with default value
    _user.add(null); // Clear user data
  }

  void dispose() {
    _phoneNumber.close();
    _fullName.close();
    _password.close();
    _confirmPassword.close();
    _user.close();
    _isLoading.close(); // Close the loading subject
  }
}
