import 'package:flutter/material.dart';
import 'character.dart';
import 'saved_characters.dart';
import 'appbar.dart';
import 'routes.dart';
import 'about.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    routes: routes,
  ));
}

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> body = [
    CharacterBodyPage(),
    MaterialsBodyPage(),
    AboutBodyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Center(child: body[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF01BE96),
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xff002c58),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: 'Saved Characters',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'About Us',
            icon: Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
