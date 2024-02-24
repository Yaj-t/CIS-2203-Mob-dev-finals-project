import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final VoidCallback onTap;

  PasswordField({
    Key? key,
    required this.labelText,
    required this.hintText,
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
    return TextFormField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefix: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Icon(
            Icons.lock,
            color: _isFocused ? Color(0xff002c58) : Color(0xFF808080),
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: widget.onTap,
          child: Icon(
            widget.obscureText ? Icons.visibility_off : Icons.visibility,
            color: _isFocused ? Color(0xff002c58) : Color(0xFF808080),
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: _isFocused ? Color(0xff002c58) : Color(0xFF808080),
        ),
        hintText: widget.hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(
            color: Color(0xFF808080),
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
        // Add any additional logic when the text changes
      },
    );
  }
}
