import 'package:flutter/material.dart';
import 'package:pics/src/blocs/exam_provider.dart';
import 'package:pics/src/models/question_model.dart';

class Question extends StatefulWidget {
  final List<String> questionIds;
  final String examId;

  Question({
    super.key,
    required this.questionIds,
    required this.examId,
  });

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final bloc = ExamProvider.of(context);

    return Scaffold(
      body: StreamBuilder<QuestionModel>(
        stream: bloc.getQuestion,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final questionData = snapshot.data;
            if (questionData != null) {
              final String? selectedOption = (questionData.answer >= 0 &&
                      questionData.answer < questionData.options.length)
                  ? questionData.options[questionData.answer]
                  : null;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.secondary, // Background color for the Card
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionData.question,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        ...questionData.options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final isSelected = selectedOption == option;

                          return Container(
                            color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                            child: ListTile(
                              title: Text(option),
                              leading: Radio<String>(
                                value: option,
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOption = value;
                                  });
                                  bloc.addAnswer(widget.examId, questionData.id, index);

                                  // Show a snackbar with the selected answer
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Selected option: $option'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              // Removed trailing icon
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 16.0),
                        StreamBuilder<int?>(
                          stream: bloc.getCounter,
                          builder: (context, counterSnapshot) {
                            final int? counterValue = counterSnapshot.data;
                            if (counterValue != null) {
                              bool isLastQuestion = counterValue == widget.questionIds.length - 1;

                              return Column(
                                children: [
                                  // Display the question number and total questions
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Question ${counterValue + 1} of ${widget.questionIds.length}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (counterValue > 0)
                                        ElevatedButton(
                                          onPressed: () {
                                            bloc.decrementCounter();
                                            bloc.fetchQuestion(
                                                widget.examId, widget.questionIds[counterValue - 1]);
                                          },
                                          child: Text('Previous'),
                                        ),
                                      if (counterValue < widget.questionIds.length - 1)
                                        ElevatedButton(
                                          onPressed: () {
                                            bloc.incrementCounter();
                                            bloc.fetchQuestion(
                                                widget.examId, widget.questionIds[counterValue + 1]);
                                          },
                                          child: Text('Next'),
                                        ),
                                      if (isLastQuestion)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle the submit action
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Submitting answers...'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                            bloc.fetchResult(widget.examId);
                                            Navigator.pushNamed(context, '/result/${widget.examId}');
                                          },
                                          child: Text('Submit'),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
