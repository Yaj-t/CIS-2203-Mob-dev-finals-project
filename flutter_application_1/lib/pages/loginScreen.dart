import 'package:flutter/material.dart';
import '../components/customtextformfield.dart';
import '../components/primarybutton.dart';
import '../components/passwordfield.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter/gestures.dart';

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
  State<LoginScreenBody> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreenBody> {
  bool obscureText = true;

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
                website_logo(),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff002c58)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const CustomTextFormField(
                  labelText: "Email Address",
                  hintText: "Enter a valid email",
                  iconData: Icons.email,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                PasswordField(
                  labelText: "Password",
                  hintText: "Enter your password",
                  iconData: Icons.lock,
                  obscureText: obscureText,
                  onTap: setPasswordVisibility,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                PrimaryButton(
                  text: "Login",
                  iconData: Icons.login,
                  onPressed: login,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    Navigator.pushNamed(context, HomeScreen.routeName);
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
          style: TextStyle(
            color: Color(0xff002c58),
            fontSize: 17.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' Register now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff18596b),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('Register now tapped!');
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class website_logo extends StatelessWidget {
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