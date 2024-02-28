import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/settings_page.dart';
import 'pages/loginScreen.dart';
import 'pages/home.dart';
import 'pages/signupPage.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
  HomeScreen.routeName: (BuildContext context) => HomeScreen(),
  SignupPage.routeName: (BuildContext context) => SignupPage(),
  '/settings': (context) => SettingsPage(),
};


/*
Color codes:
Tier 1 = 0xFFFFF5E1 Lightbrown
Tier 2 = 0xff59a8dc Lightblue
Tier 3 = 0xff002c58 Darkblue
Tier 4 = 0xff18596b DarkGreen
Tier 5 = 0xFF808080 Gray
*/