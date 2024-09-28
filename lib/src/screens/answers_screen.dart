import 'package:flutter/material.dart';
import 'package:pics/src/blocs/exam_provider.dart';
import 'package:pics/src/models/question_model.dart';

class AnswerScreen extends StatelessWidget {
  AnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = ExamProvider.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions Answer',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: StreamBuilder<List<QuestionModel>>(
        stream: bloc.getQuestions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final questionsData = snapshot.data;
            if (questionsData != null && questionsData.isNotEmpty) {
              return ListView.builder(
                itemCount: questionsData.length,
                itemBuilder: (context, index) {
                  final question = questionsData[index];
                  final isCorrect = question.answer == question.givenAnswer;
                  final answerText = question.options[question.answer];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${index + 1}: ${question.question}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 18,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            for (var i = 0; i < question.options.length; i++)
                              Text(
                                '${i + 1}. ${question.options[i]}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: question.givenAnswer == i
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : null,
                                ),
                              ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              isCorrect
                                  ? 'Your answer is correct: $answerText'
                                  : 'You are wrong. Correct answer: $answerText',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : 16,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Description: ${question.description}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No questions available'));
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
