import 'package:flutter/material.dart';
import 'package:pics/src/blocs/programs_provider.dart';
import 'package:pics/src/models/program_model.dart';
import 'package:pics/src/models/bank_model.dart'; // Import your BankModel
import 'package:pics/src/widgets/payment_method_dialog.dart'; // Import the PaymentMethodDialog widget

class ProgramDetailsScreen extends StatelessWidget {
  final String programId;

  ProgramDetailsScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);

    // Fetch program details and enrollment status
    bloc.fetchProgram(programId);
    bloc.fetchBanks(); // Trigger fetchBanks as part of the initialization

    Future<void> _showPaymentMethodDialog() async {
      showDialog(
        context: context,
        builder: (context) => PaymentMethodDialog(
          onClose: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          programId: programId,
        ),
      );
    }

    Widget mainBody(ProgramModel data, bool isEnrolled) {
      String commaSeparatedString = data.nationalExams.join(', ');

      return Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the entire column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: [
            Container(
              width: double.infinity, // Expand to the full width of the parent
              height: 200.0, // Set the height of the container
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data.imageUrl),
                  fit: BoxFit.cover, // Cover the entire container
                ),
                borderRadius: BorderRadius.circular(8.0), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  data.name,
                  style: TextStyle(
                    fontSize: 40.0, // Increase font size of the title
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black.withOpacity(0.01), 
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0), 
            Text(
              "data.description",
              style: TextStyle(
                fontSize: 23.0, // Increase font size of the description
                color: Theme.of(context).colorScheme.primary, // Set subtitle color to primary theme color
              ),
            ),
            SizedBox(height: 16.0), // Add space between description and rows below
            Row(
              children: [
                Icon(Icons.library_books, size: 24.0, color: Theme.of(context).colorScheme.primary), // Icon for Courses
                SizedBox(width: 8.0), // Gap between icon and text
                Text(
                  '${data.totalCourses}+ Courses',
                  style: TextStyle(fontSize: 20.0), // Slightly increase font size
                ),
              ],
            ),
            SizedBox(height: 8.0), // Add space between rows
            Row(
              children: [
                Icon(Icons.school, size: 24.0, color: Theme.of(context).colorScheme.primary), // Icon for Model Exams
                SizedBox(width: 8.0), // Gap between icon and text
                Text(
                  '${data.totlaModels}+ Model Exams',
                  style: TextStyle(fontSize: 20.0), // Slightly increase font size
                ),
              ],
            ),
            SizedBox(height: 8.0), // Add space between rows
            Row(
              children: [
                Icon(Icons.question_answer, size: 24.0, color: Theme.of(context).colorScheme.primary), // Icon for Mock Exams
                SizedBox(width: 8.0), // Gap between icon and text
                Text(
                  '${data.totalMocks}+ Mock Exams',
                  style: TextStyle(fontSize: 20.0), // Slightly increase font size
                ),
              ],
            ),
            SizedBox(height: 8.0), // Add space between rows
            Row(
              children: [
                Icon(Icons.assessment, size: 24.0, color: Theme.of(context).colorScheme.primary), // Icon for National Exams
                SizedBox(width: 8.0), // Gap between icon and text
                Expanded(
                  child: Text(
                    '$commaSeparatedString National Exams',
                    style: TextStyle(fontSize: 20.0), // Slightly increase font size
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0), // Add space between rows
            Row(
              children: [
                Icon(Icons.attach_money, size: 24.0, color: Theme.of(context).colorScheme.primary), // Icon for Price
                SizedBox(width: 8.0), // Gap between icon and text
                Text(
                  '${data.price} ETB',
                  style: TextStyle(
                    fontSize: 20.0, // Slightly increase font size
                    color: Colors.amber[800], // Dark yellow color for price
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Add space before button
            Center(
              child: isEnrolled
                ? TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/course/$programId');
                    },
                    child: Text(
                      'You are currently enrolled in this program',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, // Set text color to primary theme color
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _showPaymentMethodDialog,
                    child: Text(
                      'Enroll',
                      style: TextStyle(color: Colors.white), // Set button text color to white
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary, // Set button color to primary theme color
                    ),
                  ),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        print("Back button pressed");
        bloc.setEnrolledFalse();
        Navigator.pop(context);
        return false;  
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Program Details'),
          backgroundColor: Theme.of(context).colorScheme.secondary, // Set AppBar background color to secondary theme color
        ),
        body: StreamBuilder<ProgramModel>(
          stream: bloc.getProgramDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return StreamBuilder<bool>(
                stream: bloc.getEnrolled,
                builder: (context, enrollmentSnapshot) {
                  final isEnrolled = enrollmentSnapshot.data ?? false;
                  if (data != null) {
                    return mainBody(data, isEnrolled);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator()); // Replace CircularProgressIndicator with a custom loading widget
            }
          },
        ),
      ),
    );
  }
}
