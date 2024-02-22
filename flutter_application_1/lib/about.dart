import 'package:flutter/material.dart';

class AboutBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFFFF5E1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  'assets/genshin_paimon_about.png',
                  width: 250,
                  height: 250,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Hello Traveler!',
                style: TextStyle(
                  fontFamily: 'Genshin',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002c58),
                ),
              ),
              SizedBox(height: 15),
              Container(
                color: Color(0xff002c58),
                width: 350,
                height: 50,
                child: Center(
                  child: Text(
                    'Hello wazzyp',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Developers',
                style: TextStyle(
                  fontFamily: 'Genshin',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002c58),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DeveloperCard(
                    imagePath: 'assets/developer1.jpg',
                    name: 'Ivanne Bayer',
                  ),
                  SizedBox(width: 18), // Adjust the spacing between developers
                  DeveloperCard(
                    imagePath: 'assets/developer2.jpg',
                    name: 'T-jay Abunales',
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text(
                'Legends',
                style: TextStyle(
                  fontFamily: 'Genshin',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002c58),
                ),
              ),
              SizedBox(height: 15),
              Container(
                color: Color(0xff002c58),
                width: 350,
                height: 50,
                child: Center(
                  child: Text(
                    'Hello wazzyp',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Socials',
                style: TextStyle(
                  fontFamily: 'Genshin',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff002c58),
                ),
              ),
              SizedBox(height: 15),
              Container(
                color: Color(0xff002c58),
                width: 350,
                height: 50,
                child: Center(
                  child: Text(
                    'Hello wazzyp',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String imagePath;
  final String name;

  DeveloperCard({
    required this.imagePath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF5E1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(AboutBodyPage());
}
