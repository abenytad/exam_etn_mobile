import 'package:flutter/material.dart';
class LoadingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Same margin as Tile
      decoration: BoxDecoration(
        color: Colors.white, // White background
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
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30.0, // Match the size of the actual ListTile
              backgroundColor: Colors.grey[300], // Placeholder color
            ),
            title: Container(
              width: 100.0, // Placeholder width
              height: 16.0, // Placeholder height
              color: Colors.grey[300], // Placeholder color
            ),
            trailing: Container(
              width: 60.0, // Placeholder width for trailing text
              height: 16.0, // Placeholder height
              color: Colors.grey[300], // Placeholder color
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Same padding as Tile
          ),
          LinearProgressIndicator(
            color: Color.fromARGB(255, 183, 222, 253),
            backgroundColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}
