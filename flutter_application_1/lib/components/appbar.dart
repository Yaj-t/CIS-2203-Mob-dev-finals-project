import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
      ],
      backgroundColor: Color(0xff002c58),
      shape:
          const Border(bottom: BorderSide(color: Color(0xFF2D2D39), width: 2)),
      title: Row(
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                'assets/paimon_logo.png',
                width: 35,
                height: 35,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
