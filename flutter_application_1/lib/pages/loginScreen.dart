import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'signupPage.dart'; // Ensure this import is correct
import '../components/customtextformfield.dart'; // Ensure these imports are correct
import '../components/primarybutton.dart';
import '../components/passwordfield.dart';
import '../components/websiteLogo.dart';
import 'package:sign_in_button/sign_in_button.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;
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
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.w600,
                            color: Color(0xff002c58)
                          ),
                        )
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ]
                  ),
                ),

                const SizedBox(height: 20.0),

                SignInButton(Buttons.google, onPressed: handleGoogleSignIn)
                // Image.asset(
                //   'assets/google.png',
                //   width: 50.0,
                //   height: 50.0,
                // ),
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
    } on FirebaseAuthException catch(e) {
      Navigator.pop(context); // Close the dialog
      // Handle login error
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void handleGoogleSignIn() {
    try{
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      FirebaseAuth.instance.signInWithProvider(_googleAuthProvider);
    } catch (e){
      print('error');
      print(e);
      print('error');
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


