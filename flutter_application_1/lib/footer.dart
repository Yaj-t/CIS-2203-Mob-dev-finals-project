import 'package:flutter/material.dart';

class HomeFooter extends StatefulWidget {
  @override
  HomeFooterState createState() => HomeFooterState();
}

class HomeFooterState extends State<HomeFooter> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xff002c58),
      unselectedItemColor: Colors.white,
      selectedItemColor: Color(0xFF01BE96),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Characters",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download),
          label: "Battle",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_phone_rounded),
          label: "Contact",
        ),
      ],
      onTap: (int index) {
        if (index == 1) {
          // Navigate to the Dashboard screen
          // Navigator.pushNamed(context, SearchScreen.routeName);
        } else if (index == 2) {
          // Navigate to the Contact screen
          // Navigator.pushNamed(context, ContactScreen.routeName);
        }
      },
    );
  }
}
