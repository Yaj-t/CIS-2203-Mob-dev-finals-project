import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginScreen.dart'; // Ensure this import is correct
import '../components/customtextformfield.dart'; // Ensure these imports are correct
import '../components/primarybutton.dart';
import '../components/passwordfield.dart';
import '../components/websiteLogo.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = "signup";
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SignupScreenBody(),
      ),
      bottomNavigationBar: SignupFooter(),
    );
  }
}

class SignupScreenBody extends StatefulWidget {
  @override
  State<SignupScreenBody> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreenBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[200],
        body: Container(
          color: Color(0xFFFFF5E1),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WebsiteLogo(),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w800, color: Color(0xff002c58)),
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Username",
                  hintText: "Choose a unique username",
                  iconData: Icons.person,
                  textInputType: TextInputType.text,
                  controller: usernameController,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  labelText: "Email Address",
                  hintText: "Enter a valid email",
                  iconData: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 20.0),
                PasswordField(
                  labelText: "Password",
                  hintText: "Enter your password",
                  iconData: Icons.lock,
                  obscureText: obscureText,
                  onTap: setPasswordVisibility,
                  controller: passwordController,
                ),
                const SizedBox(height: 20.0),
                PasswordField(
                  labelText: "Confirm Password",
                  hintText: "Re-enter your password",
                  iconData: Icons.lock,
                  obscureText: obscureText,
                  onTap: setPasswordVisibility,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 20.0),
                PrimaryButton(
                  text: "Sign Up",
                  iconData: Icons.person_add,
                  onPressed: signup,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signup() async {
    // First, validate the passwords match.
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    // Show loading indicator.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Check if the username is unique by querying a collection where each document represents a username.
    bool usernameExists = await FirebaseFirestore.instance
      .collection('users') // Consider having a 'users' collection where each document ID is the username for easy checking.
      .where('username', isEqualTo: usernameController.text)
      .get()
      .then((querySnapshot) => querySnapshot.docs.isNotEmpty); // Check if any documents are returned.

    if (usernameExists) {
      Navigator.pop(context); // Close the loading dialog.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username is already taken. Please choose another one.')));
      return;
    }

    try {
      // Attempt to create a new user with email and password.
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Username is unique and user created successfully, now save the username to Firestore.
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': usernameController.text,
          // You can add more user-related information here.
        });

        // Optional: Send email verification.
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification email has been sent. Please check your inbox.')));
        Navigator.pop(context);
        // Close the loading dialog and maybe navigate the user to the next screen or show a success message.
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Handle various Firebase Auth exceptions, e.g., weak-password, email-already-in-use, etc.
      Navigator.pop(context); // Close the loading dialog.
      final String errorMessage = e.code == 'weak-password' ? 'The password provided is too weak.' :
                                  e.code == 'email-already-in-use' ? 'The account already exists for that email.' :
                                  e.code == 'invalid-email' ? 'The email address is invalid.' :
                                  'Failed to sign up. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }



  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}

class SignupFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFF5E1),
      height: 35.0,
      child: Text.rich(
        TextSpan(
          text: 'Already a member?',
          style: TextStyle(color: Color(0xff002c58), fontSize: 17.0),
          children: <TextSpan>[
            TextSpan(
              text: ' Login here',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff18596b)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
