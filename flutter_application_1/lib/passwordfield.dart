import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final VoidCallback onTap;

  PasswordField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.iconData,
    required this.obscureText,
    required this.onTap,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    // Define a color that is visible regardless of focus state.
    // Adjust this color to match your app's theme and ensure visibility.
    Color iconColor = Color(0xff002c58); // Example color, adjust as needed.

    return TextFormField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.iconData,
          color: iconColor, // Use the defined visible color here.
        ),
        suffixIcon: GestureDetector(
          onTap: widget.onTap,
          child: Icon(
            widget.obscureText ? Icons.visibility_off : Icons.visibility,
            color: iconColor, // Use the defined visible color here.
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: _isFocused ? Color(0xff002c58) : iconColor, // Adjusted for consistent visibility.
        ),
        hintText: widget.hintText,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(
            color: Color(0xFF808080),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(
            color: Color(0xff002c58),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _isFocused = true;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          _isFocused = false;
        });
      },
      onChanged: (value) {
        // Optional: Add any additional logic when the text changes
      },
    );
  }
}
