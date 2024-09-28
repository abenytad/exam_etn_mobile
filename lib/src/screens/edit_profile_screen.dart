import 'package:flutter/material.dart';
import 'package:pics/src/blocs/profile_provider.dart';
import 'package:pics/src/widgets/input.dart';
import 'package:pics/src/blocs/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = ProfileProvider.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: isLargeScreen ? 24 : 18), // Responsive font size
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0), // Responsive padding
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  nameField(bloc, screenWidth),
                  SizedBox(height: isLargeScreen ? 24.0 : 16.0), // Responsive spacing
                  phoneNumberField(bloc, screenWidth),
                  SizedBox(height: isLargeScreen ? 40.0 : 32.0),
                  StreamBuilder<bool>(
                    stream: bloc.isLoading,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: isLargeScreen ? 16.0 : 12.0, horizontal: isLargeScreen ? 32.0 : 24.0), // Responsive padding
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: isLargeScreen ? 18 : 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await bloc.updateProfile();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content: Text('Profile updated successfully!'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacementNamed('/home');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Failed to update profile: ${error.toString().replaceAll('Exception: ', '')}'),
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
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for phone number input field
  Widget phoneNumberField(ProfileBloc bloc, double screenWidth) {
    final isLargeScreen = screenWidth > 600;
    return StreamBuilder<int>(
      stream: bloc.getPhoneNumber,
      builder: (context, snapshot) {
        return Row(
          children: [
            Text(
              '+251',
              style: TextStyle(
                fontSize: isLargeScreen ? 18 : 14, // Responsive text size
              ),
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

  // Widget for name input field
  Widget nameField(ProfileBloc bloc, double screenWidth) {
    final isLargeScreen = screenWidth > 600;
    return Row(
      children: [
        Container(
          width: isLargeScreen ? 60.0 : 50.0, // Responsive width
          height: 1.0,
          color: Colors.transparent,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: StreamBuilder<String>(
            stream: bloc.getFullName,
            builder: (context, snapshot) {
              return InputField(
                label: 'Full Name',
                hint: 'Enter your full name',
                error: snapshot.error?.toString() ?? '',
                changedFunction: bloc.changeName,
              );
            },
          ),
        ),
      ],
    );
  }
}
