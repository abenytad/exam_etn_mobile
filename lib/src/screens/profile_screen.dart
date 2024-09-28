import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pics/src/blocs/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    final name = prefs.getString('user_name');
    final phoneNumber = prefs.getInt('user_phoneNumber');
    return {
      'name': name ?? 'N/A',
      'phoneNumber': phoneNumber != null ? phoneNumber.toString() : 'N/A',
    };
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthProvider.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: screenSize.width > 600 ? 24 : 20)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          }

          final userData = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenSize.width > 600 ? 24 : 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(screenSize.width > 600 ? 24 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${userData['name']}',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 20 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenSize.width > 600 ? 16 : 8),
                        Text(
                          'Phone Number: ${userData['phoneNumber']}',
                          style: TextStyle(
                            fontSize: screenSize.width > 600 ? 18 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.width > 600 ? 32 : 16),
                  Column(
                    children: [
                      _buildOptionTile(context, 'Edit Profile', Icons.edit, '/edit-profile'),
                      _buildOptionTile(context, 'Change Password', Icons.lock, '/password'),
                      _buildOptionTile(context, 'Customer Service', Icons.help, 'tel:0938842993'),
                    ],
                  ),
                  SizedBox(height: screenSize.width > 600 ? 32 : 16),
                  StreamBuilder(
                    stream: authBloc.isLoading,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: () async {
                          try {
                            await authBloc.logout();
                            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Logout failed: ${e.toString()}')),
                            );
                          }
                        },
                        child: Text('Log Out'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: screenSize.width > 600 ? 24 : 16),
                          textStyle: TextStyle(fontSize: screenSize.width > 600 ? 18 : 16),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: screenSize.width > 600 ? 32 : 16),
                  Text(
                    'Powered by Sekela',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: screenSize.width > 600 ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, IconData icon, String route) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.width > 600 ? 16 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: TextStyle(fontSize: screenSize.width > 600 ? 18 : 16)),
        onTap: () async {
          if (route.startsWith('tel:')) {
            final url = route;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not make the call')),
              );
            }
          } else {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
