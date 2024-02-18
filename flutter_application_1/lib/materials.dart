import 'package:flutter/material.dart';

class MaterialsBodyPage extends StatelessWidget {

  List<dynamic> enemiesData = ["abyss-mage", ];



  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff18596b)),
        ),
        onPressed: () {},
        child: Text('Battle'),
      ),
    );
  }
}

