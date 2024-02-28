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
  String? _email;
  String? _username;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
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


  void _showEditUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: "New username"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _updateUsername();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateUsername() async {
    User? user = _auth.currentUser;
    if (user != null && _usernameController!.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': _usernameController!.text,
      });
      setState(() {
        _username = _usernameController!.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username updated successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
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
