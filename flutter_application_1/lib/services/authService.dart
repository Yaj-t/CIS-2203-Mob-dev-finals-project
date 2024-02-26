import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // This method signs in with Google and returns a UserCredential
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        // Check if user is new and if so, return the UserCredential for further processing
        if (authResult.additionalUserInfo!.isNewUser) {
          print('/n user is new');
          return authResult;
        }
        return null; // If user is not new, no further action is needed
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  // This method links an email and password to an existing user account
  Future<void> linkEmailAndPasswordToAccount(String email, String password, User user) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await user.linkWithCredential(credential);
      print("Email and password linked successfully");
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}