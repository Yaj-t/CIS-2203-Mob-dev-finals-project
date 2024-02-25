import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'loginScreen.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context,snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }

          //user not logged in
          else{
            return LoginScreen();
          }
        },
      )
    );
  }
}