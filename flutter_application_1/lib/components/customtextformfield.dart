import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData iconData;
  final TextInputType textInputType;

  const CustomTextFormField({
    required this.labelText,
    required this.hintText,
    required this.iconData,
    required this.textInputType,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Icon(
            widget.iconData,
            color: _isFocused ? Color(0xff002c58) : Color(0xFF808080),
          ),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: _isFocused ? Color(0xff002c58) : Color(0xFF808080),
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
        // Add any additional logic when the text changes
      },
    );
  }
}
