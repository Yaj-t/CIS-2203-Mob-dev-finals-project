import 'package:flutter/material.dart';
import 'character.dart';
import 'battle.dart';
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
    HomeBodyPage(),
    BattleBodyPage(),
    Container(
      // Replace this with the widget you want for the third tab
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
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Menu',
            icon: Icon(Icons.menu),
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
