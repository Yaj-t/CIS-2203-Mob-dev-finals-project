import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({Key? key}) : super(key: key);

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings'); // Assuming '/settings' is the route to your settings screen.
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _navigateToSettings(context),
          icon: const Icon(Icons.settings),
        ),
      ],
      backgroundColor: const Color(0xff002c58),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFF2D2D39), width: 2),
      ),
      title: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // You can handle on tap here
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
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
