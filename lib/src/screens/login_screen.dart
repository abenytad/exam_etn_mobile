import 'package:flutter/material.dart';
import 'package:pics/src/blocs/auth_provider.dart';
import 'package:pics/src/blocs/auth_bloc.dart';
import 'package:pics/src/widgets/input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bloc = AuthProvider.of(context);

    // Get the screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600; // Define threshold for large screens

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Login', style: TextStyle(fontSize: isLargeScreen ? 24 : 20)), // Responsive font size
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoading,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView( // Allows scrolling if content exceeds the screen size
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenSize.height, // Occupies full screen height
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0), // Responsive padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/logg.png',
                              height: isLargeScreen ? 120.0 : 80.0, // Responsive image height
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              'assets/letter.png',
                              height: isLargeScreen ? 50.0 : 35.0, // Responsive image height
                            ),
                          ),
                          SizedBox(height: 32.0),
                          _buildPhoneNumberField(bloc),
                          SizedBox(height: 16.0),
                          _buildPasswordField(bloc),
                          SizedBox(height: 32.0),
                          StreamBuilder(
                            stream: bloc.getValidSignInInput(),
                            builder: (context, itemSnapshot) {
                              return ElevatedButton(
                                onPressed: isLoading || !itemSnapshot.hasData
                                    ? null
                                    : () async {
                                        try {
                                          await bloc.fetchUser();
                                          Navigator.pushNamed(context, '/home');
                                        } catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Error'),
                                              content: Text(e.toString().replaceAll('Exception: ', '')),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).colorScheme.primary,
                                  onPrimary: Theme.of(context).colorScheme.secondary,
                                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  textStyle: TextStyle(
                                    fontSize: isLargeScreen ? 18 : 14, // Responsive font size
                                  ),
                                ),
                                child: Text('Sign In'),
                              );
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'Don\'t have an account? Sign up',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: isLargeScreen ? 16 : 14, // Responsive font size
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: Text(
                              'Powered by Sekela',
                              style: TextStyle(
                                fontSize: isLargeScreen ? 16 : 14, // Responsive font size
                                color: Colors.amber,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
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
  Widget _buildPhoneNumberField(AuthBloc bloc) {
    return StreamBuilder<int>(
      stream: bloc.getPhoneNumber,
      builder: (context, snapshot) {
        final isLargeScreen = MediaQuery.of(context).size.width > 600; // Responsive size

        return Row(
          children: [
            Text(
              '+251',
              style: TextStyle(fontSize: isLargeScreen ? 18.0 : 16.0), // Responsive font size
            ),
            SizedBox(width: 8.0),
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


  Widget _buildPasswordField(AuthBloc bloc) {
    return Row(
      children: [
        SizedBox(width: 52.0), // Empty box on the left
        Expanded(
          child: StreamBuilder<String>(
            stream: bloc.getPassword,
            builder: (context, snapshot) {
              return InputField(
                label: 'Password',
                hint: 'Enter your password',
                error: snapshot.error?.toString() ?? '',
                obscureText: _obscurePassword,
                changedFunction: bloc.changePassword,
                toggleObscureText: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              );
            },
          ),
        ),
        SizedBox(width: 8.0), // Empty box on the right
      ],
    );
  }
}
