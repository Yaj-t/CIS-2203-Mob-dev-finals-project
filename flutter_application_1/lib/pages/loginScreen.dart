import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'signupPage.dart'; // Ensure this import is correct
import '../components/customtextformfield.dart'; // Ensure these imports are correct
import '../components/primarybutton.dart';
import '../components/passwordfield.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginScreenBody(),
      ),
      bottomNavigationBar: LoginFooter(),
    );
  }
}

class LoginScreenBody extends StatefulWidget {
  @override
  State<LoginScreenBody> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                const SizedBox(height: 20.0),
                const Text(
                  'Login',
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
                PrimaryButton(
                  text: "Login",
                  iconData: Icons.login,
                  onPressed: login,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Close the dialog
      // Navigate to the next screen if login is successful
      Navigator.pushNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException {
      Navigator.pop(context); // Close the dialog
      // Handle login error
      final errorMessage = 'Invalid Email or Password';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFF5E1),
      height: 35.0,
      child: Text.rich(
        TextSpan(
          text: 'Not yet a member?',
          style: TextStyle(color: Color(0xff002c58), fontSize: 17.0),
          children: <TextSpan>[
            TextSpan(
              text: 'Signup now',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff18596b)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, SignupPage.routeName);
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
