import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final String error;
  final void Function(String) changedFunction;
  final bool obscureText; // Add this to control password visibility
  final void Function()? toggleObscureText; // Add this to handle icon tap

  InputField({
    super.key,
    required this.label,
    required this.hint,
    required this.error,
    required this.changedFunction,
    this.obscureText = false, // Default value is false
    this.toggleObscureText,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: 200.0,
      child: TextField(
        obscureText: obscureText, // Use the obscureText property
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          labelText: label,
          hintText: hint,
          errorText: error,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          suffixIcon: toggleObscureText != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: toggleObscureText, // Call the toggle function
                )
              : null,
        ),
        onChanged: changedFunction,
      ),
    );
  }
}
