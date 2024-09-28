import 'package:flutter/material.dart';
import 'package:pics/src/blocs/auth_provider.dart';
import 'package:pics/src/blocs/auth_bloc.dart';
import 'package:pics/src/widgets/input.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true; // State for password visibility
  bool _obscureConfirmPassword = true; // State for confirm password visibility

  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoading,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;

          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        nameField(bloc),
                        SizedBox(height: 16.0),
                        phoneNumberField(bloc),
                        SizedBox(height: 16.0),
                        passwordField(bloc),
                        SizedBox(height: 16.0),
                        confirmPasswordField(bloc),
                        SizedBox(height: 16.0),
                        StreamBuilder(
                          stream: bloc.getValidSignUpInput(),
                          builder: (context, itemSnapshot) {
                            return Center(
                              child: SizedBox(
                                width: 200, // Reduced button width
                                child: ElevatedButton(
                                  onPressed: isLoading || !itemSnapshot.hasData
                                      ? null
                                      : () async {
                                          if (await bloc
                                              .getValidSignUpInput()
                                              .first) {
                                            try {
                                              await bloc.signupUser();
                                              Navigator.pushNamed(
                                                  context, '/');
                                            } catch (e) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text(e
                                                      .toString()
                                                      .replaceAll(
                                                          'Exception: ', '')),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title: Text('Error'),
                                                content: Text(
                                                    'Password and Confirm Password fields must be the same'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    onPrimary: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  child: Text('Sign Up'),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget nameField(AuthBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.getFullName,
      builder: (context, snapshot) {
        return InputField(
          label: 'Full Name',
          hint: 'Enter your full name',
          error: snapshot.error?.toString() ?? '',
          changedFunction: bloc.changeName,
        );
      },
    );
  }

  Widget phoneNumberField(AuthBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.getPhoneNumber,
      builder: (context, snapshot) {
        return Row(
          children: [
            Container(
              width: 60.0,
              alignment: Alignment.center,
              child: Text('+251'),
            ),
            Expanded(
              child: InputField(
                label: 'Phone Number',
                hint: 'Start with 9 or 7',
                error: snapshot.error?.toString() ?? '',
                changedFunction: (value) {
                  final phoneNumber = int.tryParse(value);
                  if (phoneNumber != null) {
                    bloc.changePhoneNumber(phoneNumber);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget passwordField(AuthBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.getPassword,
      builder: (context, snapshot) {
        return InputField(
          label: 'Password',
          hint: 'Enter your password',
          error: snapshot.error?.toString() ?? '',
          changedFunction: bloc.changePassword,
          obscureText: _obscurePassword, // Pass the state
          toggleObscureText: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        );
      },
    );
  }

  Widget confirmPasswordField(AuthBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.getConfirmPassword,
      builder: (context, snapshot) {
        return InputField(
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          error: snapshot.error?.toString() ?? '',
          changedFunction: bloc.changeConfirmPassword,
          obscureText: _obscureConfirmPassword, // Pass the state
          toggleObscureText: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        );
      },
    );
  }
}
