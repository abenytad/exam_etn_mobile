import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:pics/src/blocs/chatbot_provider.dart';

class ChatBotScreen extends StatefulWidget {
  ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(); // Initialize the text controller
  }

  @override
  void dispose() {
    _textController.dispose(); // Dispose of the text controller when done
    super.dispose();
  }

  // Function to copy text to the clipboard and show a snackbar notification
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  // Function to build message widgets, with special handling for code blocks
  Widget _buildMessage(String message, bool isSentByUser) {
    bool isCode = message.startsWith('```') && message.endsWith('```'); // Check if message is code

    if (isCode) {
      // Remove the ``` code block markers
      String code = message.substring(3, message.length - 3).trim();
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSentByUser ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: isSentByUser ? Colors.white : Colors.black,
                fontFamily: 'Courier', // Use monospace font for code
                fontSize: 16,
              ),
              children: _buildCodeTextSpans(code),
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSentByUser ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByUser ? Colors.white : Colors.black,
            fontSize: 16, // Adjust font size for readability on various screen sizes
          ),
        ),
      );
    }
  }

  // Helper function to build text spans for displaying code
  List<TextSpan> _buildCodeTextSpans(String code) {
    List<TextSpan> spans = [];
    List<String> lines = code.split('\n');
    for (String line in lines) {
      spans.add(TextSpan(
        text: line + '\n',
        style: TextStyle(
          color: Colors.lightGreen, // Color for code text
        ),
      ));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ChatbotProvider.of(context); // Access the bloc using the provider

    // Get screen size from MediaQuery for responsiveness
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Get keyboard height from MediaQuery
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Access the secondary color from the theme
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
        backgroundColor: secondaryColor, // Set AppBar background color
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<String>>(
                  stream: bloc.messagesStream,
                  builder: (context, snapshot) {
                    final messages = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        // Determine if the message is from the user or from the AI
                        final isSentByUser = index % 2 == 0; // Replace with actual check if available
                        return _buildMessage(message, isSentByUser);
                      },
                    );
                  },
                ),
              ),
              // The SizedBox height is set to keyboardHeight to ensure space for the input area
              SizedBox(height: keyboardHeight),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0), // Added padding for better spacing
              width: screenSize.width, // Set width to screen width for full-screen width input area
              color: secondaryColor, // Set bottom navigation bar background color
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<String>(
                      stream: bloc.getText,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white, // Set TextField background color
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isPortrait ? 12.0 : 16.0, // Adjust padding for portrait/landscape
                              horizontal: 16.0,
                            ),
                          ),
                          onChanged: bloc.changeText,
                          style: TextStyle(fontSize: 16), // Adjust font size for readability
                        );
                      },
                    ),
                  ),
                  StreamBuilder<String>(
                    stream: bloc.getText,
                    builder: (context, snapshot) {
                      final isTextEmpty = snapshot.data == null || snapshot.data!.isEmpty;
                      return IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.white, // Set send button icon color
                        onPressed: isTextEmpty
                            ? null
                            : () {
                                bloc.submit();
                                _textController.clear(); // Clear the text field
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
