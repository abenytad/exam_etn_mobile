// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:pics/src/blocs/programs_provider.dart';
import 'package:pics/src/models/program_model.dart';
import 'loading_tile.dart';

class Tile extends StatelessWidget {
  final String programId;

  const Tile({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);
    return StreamBuilder<Map<String, Future<ProgramModel>>>(
      stream: bloc.programs,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LoadingTile());
        }
        final futureProgram = snapshot.data![programId];
        return FutureBuilder<ProgramModel>(
          future: futureProgram,
          builder: (context, itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Center(child: LoadingTile());
            }
            final programModel = itemSnapshot.data!;
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add margin for spacing
              decoration: BoxDecoration(
                color: Colors.white, // White background for ListTile
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0, // Increase size of leading image
                  foregroundImage: NetworkImage(programModel.imageUrl),
                ),
                title: Text(
                  programModel.name,
                  style: TextStyle(
                    fontSize: 18.0, // Increase font size if desired
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.9), // Slightly lighter than 0.87
                  ),
                ),
                trailing: programModel.enrolled 
                  ? Text("Enrolled", style: TextStyle(color: Colors.green)) 
                  : null, // Remove icon, show "Enrolled" text if applicable
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Increase height of ListTile
                onTap: () {
                  if (programModel.enrolled) {
                    Navigator.pushNamed(context, '/course/${programModel.id}');
                  } else {
                    Navigator.pushNamed(context, '/program/$programId');
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
