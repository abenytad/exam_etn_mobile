import 'package:flutter/material.dart';
import 'package:pics/src/blocs/exam_provider.dart';

class ResultScreen extends StatelessWidget {
  final String examId;
  ResultScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final bloc = ExamProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        backgroundColor: Theme.of(context).colorScheme.secondary, // Set the AppBar background color
      ),
      body: StreamBuilder<int>(
        stream: bloc.getResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final correctAnswers = snapshot.data ?? 0;
            final totalQuestions = 10; // Total number of questions
            final percentage = (correctAnswers / totalQuestions) * 100;

            String resultCategory;
            Color categoryColor;

            // Categorize the result
            if (percentage >= 85) {
              resultCategory = 'Excellent';
              categoryColor = Colors.green;
            } else if (percentage >= 75) {
              resultCategory = 'Very Good';
              categoryColor = Colors.blue;
            } else if (percentage >= 65) {
              resultCategory = 'Good Achievement';
              categoryColor = Colors.orange;
            } else if (percentage >= 50) {
              resultCategory = 'Satisfactory';
              categoryColor = Colors.yellow;
            } else {
              resultCategory = 'Needs Improvement';
              categoryColor = Colors.red;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Score',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          resultCategory,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/answers/$examId');
                    },
                    child: Text('Go to Answers'),
                  ),
                ],
              ),
            );
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
