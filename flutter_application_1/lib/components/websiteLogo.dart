import 'package:flutter/material.dart';

class WebsiteLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Image.asset(
          'assets/website_logo.png',
          width: 250.0,
          height: 250.0,
        ),
      ],
    );
  }
}