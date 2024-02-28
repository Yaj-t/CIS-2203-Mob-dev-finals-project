import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutBodyPage extends StatelessWidget {
  final Uri _url = Uri.parse('https://github.com/genshindev/api');

  AboutBodyPage({Key? key}) : super(key: key);

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<String?> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['username'] as String?;
      }
    }
    return null;
  }

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
              FutureBuilder<String?>(
                future: fetchUsername(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final String username = snapshot.data ?? "Traveler";
                  return Text(
                    'Hello, $username!',
                    style: TextStyle(
                      fontFamily: 'Genshin',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff002c58),
                    ),
                  );
                },
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff002c58),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                height: 225,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'This app draws inspiration from the popular game Genshin Impact, aiming to assist fellow travelers in preparing the essential materials required for characters in upcoming banners. Whether it\'s ascension materials, boss drops, or talent level-up items, our app is designed to help you plan and gather the resources you need for your favorite characters in the world of Teyvat.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
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
                decoration: BoxDecoration(
                  color: Color(0xff002c58),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                height: 750,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendText('Ascension Shard',
                            'Special crystals for character ascension. Obtained from elite bosses and quests.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Boss Materials',
                            'Rare drops from powerful world bosses. Used for ascension and talent upgrades.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Local Materials',
                            'Region-specific items. Collected in the open world for ascension and talents.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Common Materials',
                            'General items found throughout the world. Used for ascension and talents.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Weekly Materials',
                            'Special drops from weekly bosses. Essential for character progression.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Talent Materials',
                            'Essential items to level up character talents. Obtained from elite bosses and domains.'),
                        SizedBox(height: 5),
                        Divider(color: Color(0xFFFFF5E1)),
                        SizedBox(height: 5),
                        _buildLegendText('Paimon Icon',
                            'If information from the API is not updated, a Paimon icon will be displayed shown below:'),
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/paimon_empty.png',
                          width: 50,
                          height: 50,
                        ),
                      ],
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
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: _launchUrl,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        OctIcons.mark_github_16,
                        size: 25,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Genshin Dev API',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
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

Widget _buildLegendText(String title, String description) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

void main() {
  runApp(AboutBodyPage());
}
