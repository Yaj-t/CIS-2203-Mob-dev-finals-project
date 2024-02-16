import 'package:flutter/material.dart'; 

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}