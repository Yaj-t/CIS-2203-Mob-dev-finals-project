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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            if (user.emailVerified) {
              return HomeScreen();
            } else {
              Future.microtask(() => showVerifyEmailSentDialog(context, user));
              return const LoginScreen(); // Or a placeholder screen that tells the user to verify their email.
            }
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  void showVerifyEmailSentDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Verify Your Email"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A verification email has been sent to your email address.'),
                Text('Please verify your email to continue.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Resend Email'),
              onPressed: () {
                user.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Done'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
