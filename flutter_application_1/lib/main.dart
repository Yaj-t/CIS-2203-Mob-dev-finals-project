import 'package:flutter/material.dart';
import 'routes.dart';
import 'pages/loginScreen.dart';
import 'pages/signUppage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const LoginScreen(),
    routes: routes,
  ));
}


