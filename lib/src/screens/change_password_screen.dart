import 'package:flutter/material.dart';
import 'package:pics/src/blocs/profile_provider.dart';
import 'package:pics/src/widgets/input.dart';
import 'package:pics/src/blocs/profile_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final bloc = ProfileProvider.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            oldPassword(bloc, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            newPassword(bloc, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            confirmPassword(bloc, screenWidth),
            SizedBox(height: screenHeight * 0.04),
            StreamBuilder<bool>(
              stream: bloc.isLoading,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return StreamBuilder<String>(
                    stream: bloc.errorMessage,
                    builder: (context, errorSnapshot) {
                      if (errorSnapshot.hasData && errorSnapshot.data!.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showDialog(context, 'Error', errorSnapshot.data!);
                        });
                      }
                      return StreamBuilder<String>(
                        stream: bloc.successMessage,
                        builder: (context, successSnapshot) {
                          if (successSnapshot.hasData && successSnapshot.data!.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _showDialog(context, 'Success', successSnapshot.data!);
                            });
                          }
                          return StreamBuilder<bool>(
                            stream: bloc.isValidPasswordInput,
                            builder: (context, validSnapshot) {
                              final isEnabled = validSnapshot.data ?? false;
                              return Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).colorScheme.primary, // Background color
                                  ),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                  onPressed: isEnabled
                                      ? () async {
                                          try {
                                            await bloc.updatePassword();
                                            Navigator.popAndPushNamed(context, '/home');
                                          } catch (e) {
                                            _showDialog(context, 'Error', 'Error updating password: ${e.toString().replaceAll('Exception: ', '')}');
                                          }
                                        }
                                      : null,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget oldPassword(ProfileBloc bloc, double screenWidth) {
    return StreamBuilder<String>(
      stream: bloc.getOldPassword,
      builder: (context, snapshot) {
        return InputField(
          label: 'Old Password',
          hint: 'Enter your old password',
          error: snapshot.error?.toString() ?? '',
          obscureText: _obscureOldPassword,
          toggleObscureText: () {
            setState(() {
              _obscureOldPassword = !_obscureOldPassword;
            });
          },
          changedFunction: bloc.changeOldPassword,
          
        );
      },
    );
  }

  Widget newPassword(ProfileBloc bloc, double screenWidth) {
    return StreamBuilder<String>(
      stream: bloc.getNewPassword,
      builder: (context, snapshot) {
        return InputField(
          label: 'New Password',
          hint: 'Enter your new password',
          error: snapshot.error?.toString() ?? '',
          obscureText: _obscureNewPassword,
          toggleObscureText: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
          changedFunction: bloc.changeNewPassword,
        );
      },
    );
  }

  Widget confirmPassword(ProfileBloc bloc, double screenWidth) {
    return StreamBuilder<String>(
      stream: bloc.getConfirmPassword,
      builder: (context, snapshot) {
        return InputField(
          label: 'Confirm Password',
          hint: 'Re-enter your new password',
          error: snapshot.error?.toString() ?? '',
          obscureText: _obscureConfirmPassword,
          toggleObscureText: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          changedFunction: bloc.changeConfirmPassword,
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
