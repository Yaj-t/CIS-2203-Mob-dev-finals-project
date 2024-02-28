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
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Check if the username is unique
    final usernameExists = await FirebaseFirestore.instance
      .collection('usernames')
      .doc(usernameController.text)
      .get()
      .then((doc) => doc.exists);

    if (usernameExists) {
      Navigator.pop(context); // Close the dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username is already taken. Please choose another one.')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Add the username to Firestore
        await FirebaseFirestore.instance.collection('usernames').doc(usernameController.text).set({
          'userId': user.uid,
        });
        print("here");

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification email has been sent. Please check your inbox.')));
        }

        Navigator.pop(context); // Close the dialog
        // Navigate to the next screen or show a success message
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the dialog
      final String errorMessage = e.code == 'weak-password' ? 'The password provided is too weak.' :
                                  e.code == 'email-already-in-use' ? 'The account already exists for that email.' :
                                  e.code == 'invalid-email' ? 'The email address is Invalid.' :
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
