import 'package:flutter/material.dart';
import 'character.dart';
import 'materials.dart';
import 'appbar.dart';
import 'routes.dart';

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
    Container(
      color: Colors.blue,
      child: Center(child: Text('Person Tab')),
    ),
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
            label: 'Characters',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Battle',
            icon: Icon(Icons.download),
          ),
          BottomNavigationBarItem(
            label: 'Person',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
