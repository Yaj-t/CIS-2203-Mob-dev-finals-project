import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';


final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (BuildContext context) => LoginScreen(),
  HomeScreen.routeName: (BuildContext context) => HomeScreen(),
};


/*
Color codes:
Tier 1 = 0xFFFFF5E1 Lightbrown
Tier 2 = 0xff59a8dc Lightblue
Tier 3 = 0xff002c58 Darkblue
Tier 4 = 0xff18596b DarkGreen
Tier 5 = 0xFF808080 Gray
*/