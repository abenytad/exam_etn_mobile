import 'package:flutter/material.dart';
import 'package:pics/src/blocs/programs_provider.dart';

class MaterialsScreen extends StatelessWidget {
  final String courseId;
  MaterialsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600; // Define threshold for large screens

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Materials Page',
          style: TextStyle(fontSize: isLargeScreen ? 24 : 20), // Responsive font size
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: StreamBuilder(
        stream: bloc.getMaterials,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data != null) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 24.0 : 16.0, // Responsive padding
                  vertical: isLargeScreen ? 16.0 : 8.0,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final material = data[index];
                  final isPdf = material.type == 'pdf';
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: isLargeScreen ? 8.0 : 4.0), // Responsive margin
                    child: Card(
                      elevation: isLargeScreen ? 8.0 : 4.0, // Responsive shadow effect
                      child: ListTile(
                        leading: Icon(
                          isPdf ? Icons.picture_as_pdf : Icons.video_collection,
                          color: isPdf ? Colors.red : Colors.blue,
                          size: isLargeScreen ? 32.0 : 24.0, // Responsive icon size
                        ),
                        title: Text(
                          material.name,
                          style: TextStyle(fontSize: isLargeScreen ? 18 : 16), // Responsive font size
                        ),
                        subtitle: Text(
                          material.description,
                          style: TextStyle(fontSize: isLargeScreen ? 16 : 14), // Responsive font size
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            isPdf
                                ? '/pdf/${material.materialUrl}'
                                : '/video/${material.materialUrl}',
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
