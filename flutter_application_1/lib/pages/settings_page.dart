import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? _usernameController;
  TextEditingController? _newPasswordController;
  TextEditingController? _confirmPasswordController;
  String? _email;
  String? _username;

  @override
 void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loadUserData();
  }

  _loadUserData() async {
    User? user = _auth.currentUser;
    _email = user?.email;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      var data = userData.data();
      if (data is Map<String, dynamic>) { // Explicitly cast the data to Map<String, dynamic>
        setState(() {
          _username = data['username'] as String?; // Safely access the 'username' field
          _usernameController?.text = _username ?? '';
        });
      }
    }
  }

  void _showChangePasswordDialog() {
    // Initialize password visibility state
    bool _obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage state inside the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      hintText: "Enter new password",
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm new password",
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Clear the text fields when the dialog is closed
                    _newPasswordController!.clear();
                    _confirmPasswordController!.clear();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_newPasswordController!.text == _confirmPasswordController!.text) {
                      _changePassword();
                      // Close dialog after updating password and clear the text fields
                      _newPasswordController!.clear();
                      _confirmPasswordController!.clear();
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
                      // Do not clear text fields here to allow the user to correct them
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      // Optionally, ensure the text fields are cleared if the dialog is dismissed by other means
      _newPasswordController!.clear();
      _confirmPasswordController!.clear();
    });
  }


  void _changePassword() async {
    User? user = _auth.currentUser;
    String newPassword = _newPasswordController!.text;

    if (user != null && newPassword.isNotEmpty) {
      try {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated successfully")));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Re-authenticate the user here
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please re-authenticate to change your password.")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred. Please try again.")));
        }
      }
    }
  }


  void _showEditUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Temporary controller to hold new username input
        TextEditingController tempUsernameController = TextEditingController();

        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            controller: tempUsernameController,
            decoration: InputDecoration(hintText: "New username"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                // No need to clear tempUsernameController since it will be disposed
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _usernameController!.text = tempUsernameController.text; // Set the new username to the main controller
                _updateUsername();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      // Optionally, clear the main username controller after the dialog is closed
      // to ensure it's empty the next time the dialog is opened
      _usernameController!.clear();
    });
  }


  void _updateUsername() async {
    User? user = _auth.currentUser;
    if (user != null && _usernameController!.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'username': _usernameController!.text,
        });
        print("Username updated in Firestore");
        
        // Refresh user data to reflect the updated username
        await _loadUserData();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username updated successfully")));
      } catch (e) {
        print("Error updating username: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update username")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E1),
      appBar: AppBar(title: Text('Settings'), backgroundColor: Color(0xff002c58),),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Email'),
              subtitle: Text(_email ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Username'),
              subtitle: Text(_username ?? 'No username'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: _showEditUsernameDialog,
              ),
            ),
            ListTile(
              title: Text('Password'),
              subtitle: Text('********'), // Placeholder for password
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: _showChangePasswordDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    super.dispose();
  }
}
