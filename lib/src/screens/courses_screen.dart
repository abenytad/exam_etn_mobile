import 'package:flutter/material.dart';
import 'package:pics/src/blocs/programs_provider.dart';

class CoursesScreen extends StatelessWidget {
  final String programId;
  
  CoursesScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses', style: TextStyle(fontSize: isLargeScreen ? 24 : 18)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: bloc.getCourses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data != null) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: isLargeScreen ? 16.0 : 8.0,
                          ),
                          child: Card(
                            elevation: 4.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: isLargeScreen ? 30 : 20,
                                foregroundImage: NetworkImage(data[index].imageUrl),
                              ),
                              title: Text(
                                data[index].name,
                                style: TextStyle(fontSize: isLargeScreen ? 18 : 14),
                              ),
                              subtitle: Text(
                                data[index].description,
                                style: TextStyle(fontSize: isLargeScreen ? 16 : 12),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/materials/${data[index].id}',
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: isLargeScreen ? 32.0 : 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/mockExam/$programId');
                    },
                    child: Text('Mock Exam', style: TextStyle(fontSize: isLargeScreen ? 18 : 14)),
                  ),
                ),
                SizedBox(width: isLargeScreen ? 32.0 : 16.0),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatbot');
                    },
                    child: Text('Chatbot', style: TextStyle(fontSize: isLargeScreen ? 18 : 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
