// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:pics/src/blocs/programs_provider.dart';
import 'package:pics/src/models/program_model.dart';
import 'package:pics/src/widgets/loading_tile.dart'; // Assuming you have a custom loading widget with an indicator line

class Programs extends StatelessWidget {
  Programs({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);
    bloc.enrolledPrograms();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
            alignment: Alignment.center, // Center the title horizontally
            child: Text(
              'Enrolled Programs',
              style: TextStyle(
                fontSize: 20.0, // Reduced font size of the title
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title color
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ProgramModel>>(
              stream: bloc.getEnrolledPrograms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data != null && data.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduce vertical padding
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0), // Reduce gap between list items
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.0), // Reduce padding inside the ListTile
                            leading: CircleAvatar(
                              radius: 30.0, // Increase the size of the image
                              foregroundImage: NetworkImage(data[index].imageUrl),
                            ),
                            title: Text(
                              data[index].name,
                              style: TextStyle(
                                fontSize: 16.0, // Font size of the title
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Title color
                              ),
                            ),
                            subtitle: Text(
                              data[index].description,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.primary, // Subtitle color
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/course/${data[index].id}');
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('You are not enrolled in any programs'),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView(
                    children: List.generate(
                      4, // Number of loading indicators to display
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LoadingTile(), // Custom loading widget
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
