// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import '../blocs/programs_provider.dart';
import 'package:pics/src/blocs/programs_provider.dart';

import 'tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  final List<String> _imagePaths = [
    'assets/1-01-01.jpg', // Replace with your asset paths
    'assets/1-01-02.jpg',
    'assets/1-01-03.jpg',
    'assets/1-01-04.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(Duration(seconds: 5), () { // Delay for scrolling
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_pageController.page!.toInt() + 1) % _imagePaths.length,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.0), // Reduced gap above the image carousel
          Container(
            height: 140.0, // Reduced height for the image carousel
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // Gap between images
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(blurRadius: 4, color: Colors.black26)
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        _imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.0), // Reduced gap below the image carousel
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Reduced padding around the title
            child: Text(
              'Available Programs',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: bloc.getTopIds,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data != null) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final programId = data[index];
                        bloc.fetchProgram(programId);
                        return Tile(programId: programId);
                      },
                    );
                  } else {
                    return Text('No data available');
                  }
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
