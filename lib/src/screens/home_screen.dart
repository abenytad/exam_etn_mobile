import 'package:flutter/material.dart';
import '../widgets/home.dart';
import '../widgets/programs.dart';
import '../blocs/programs_bloc.dart';
import '../blocs/programs_provider.dart';
import '../blocs/auth_provider.dart'; // Import AuthProvider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [Home(), Programs()];

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);
    final authBloc = AuthProvider.of(context); // Get AuthBloc

    bloc.fetchTopIds();

    // Get the screen width to make responsive decisions
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Define threshold for large screens

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary, // Set AppBar color to secondary theme color
        leading: IconButton(
          icon: Image.asset(
            'assets/logg.png',
            height: isLargeScreen ? 50.0 : 35.0, // Responsive image height
          ),
          onPressed: () {
            // Add functionality if needed
          },
        ),
        title: Image.asset(
          'assets/letter.png',
          height: isLargeScreen ? 40.0 : 25.0, // Responsive image height
        ), // Title with image
        actions: [
          IconButton(
            icon: Icon(Icons.person, size: isLargeScreen ? 30.0 : 24.0, color: Colors.grey), // Responsive icon size
            onPressed: () {
              Navigator.pushNamed(context, '/profile'); // Navigate to profile page
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        backgroundColor: Theme.of(context).colorScheme.secondary, // Set BottomNavigationBar background color to secondary color
        selectedItemColor: Colors.white, // Set selected item color
        unselectedItemColor: Colors.grey, // Set unselected item color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: isLargeScreen ? 30.0 : 24.0), // Responsive icon size
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, size: isLargeScreen ? 30.0 : 24.0), // Responsive icon size
            label: 'My Programs',
          ),
        ],
      ),
    );
  }
}
