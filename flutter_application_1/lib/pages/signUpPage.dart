import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginScreen.dart'; // Ensure this import is correct
import '../components/customtextformfield.dart'; // Ensure these imports are correct
import '../components/primarybutton.dart';
import '../components/passwordfield.dart';

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
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
    if (passwordController.text == confirmPasswordController.text) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from closing on tap
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context); // Close the dialog
        // Navigate to the next screen if signup is successful
        Navigator.pop(context);
      } on FirebaseAuthException {
        Navigator.pop(context); // Close the dialog
        // Handle signup error
        final errorMessage = 'Failed to sign up. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      // Handle password mismatch
      final errorMessage = 'Passwords do not match.';
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

class WebsiteLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Image.asset(
          'assets/website_logo.png',
          width: 300.0,
          height: 300.0,
        ),
      ],
    );
  }
}
