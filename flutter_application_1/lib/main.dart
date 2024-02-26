import 'package:flutter/material.dart';
import 'routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'pages/auth_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: AuthPage(),
    routes: routes,
  ));
}


