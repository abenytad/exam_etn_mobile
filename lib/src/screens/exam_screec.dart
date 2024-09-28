import 'package:flutter/material.dart';
import 'package:pics/src/blocs/exam_provider.dart';
import 'package:pics/src/widgets/question.dart';

class ExamScreen extends StatelessWidget {
  ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = ExamProvider.of(context);
    final theme = Theme.of(context); // Get the theme for color access
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Adjust threshold based on your needs

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mock Exam',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : 18, // Responsive font size
          ),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0), // Responsive padding
        child: StreamBuilder(
          stream: bloc.getExam,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final examData = snapshot.data;
              if (examData != null) {
                final questionIds = examData.questionIds;
                bloc.fetchQuestion(examData.id, questionIds[0]);

                return Question(
                  questionIds: questionIds,
                  examId: examData.id,
                );
              } else {
                return Center(
                  child: Text(
                    'No exam data available',
                    style: TextStyle(fontSize: isLargeScreen ? 18 : 14), // Responsive text size
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: isLargeScreen ? 18 : 14), // Responsive text size
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: isLargeScreen ? 4.0 : 2.0, // Responsive stroke width
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
