import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaterialsBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtain the current user
    final user = FirebaseAuth.instance.currentUser;
    // Check if the user is not null to avoid errors
    final userEmail = user?.email ?? 'No email available';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // This centers the button and text vertically
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {},
            child: Text('Saved Character'),
          ),
          SizedBox(height: 20), // Provide some spacing
          Text(
            userEmail, // Display the user's email
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
