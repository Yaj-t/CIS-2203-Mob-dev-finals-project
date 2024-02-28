import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../services/apiservice.dart';
import '../styles/color.dart';
import 'detailswidget.dart';

class CharactersDetailsPage extends StatefulWidget {
  final String character;
  final String vision;

  CharactersDetailsPage({required this.character, required this.vision});

  @override
  CharactersDetailsPageState createState() =>
      CharactersDetailsPageState(character: character, vision: vision);
}

class CharactersDetailsPageState extends State<CharactersDetailsPage> {
   final String character;
  final String vision;
  final Logger logger = Logger();
  bool isFavorite = false;

  CharactersDetailsPageState({required this.character, required this.vision});
  ApiService apiService = ApiService();

  @override
  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Assuming you have a method to fetch the username from the user's document
      String? username = await fetchUsername(user.uid);
      if (username != null) {
        var doc = await FirebaseFirestore.instance
            .collection('usernameData') // Use the actual collection name that stores username-related data
            .doc(username) // Use the username as the document ID or as part of the path
            .collection('favorites')
            .doc(character)
            .get();
        setState(() {
          isFavorite = doc.exists;
        });
      }
    }
  }

  void toggleFavorite() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the username for the current user
      String? username = await fetchUsername(user.uid);
      if (username != null) {
        var docRef = FirebaseFirestore.instance
            .collection('usernameData') // Adjust based on your collection structure
            .doc(username) // Use username to reference the correct document
            .collection('favorites')
            .doc(character);

        if (isFavorite) {
          // Remove from favorites
          await docRef.delete();
        } else {
          // Add to favorites
          await docRef.set({'character': character, 'vision': vision});
        }
        setState(() {
          isFavorite = !isFavorite;
        });
      }
    } else {
      logger.e('User is not logged in');
    }
  }

  Future<String?> fetchUsername(String userId) async {
    // Fetch the username using the user's UID
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data()!.containsKey('username')) {
      return userDoc.data()!['username'] as String?;
    }
    return null;
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getVisionSecondaryColor(vision),
      appBar: AppBar(
        backgroundColor: Color(0xff002c58),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            apiService.fetchPortrait(character),
            apiService.fetchVisionIcon(vision),
            apiService.fetchAscensionMaterials(vision),
            apiService.fetchBossAscensionMaterials(character),
            apiService.fetchLocalAscensionMaterials(character),
            apiService.fetchCommonAscensionMaterials(character),
            apiService.fetchWeeklyBossAscensionMaterials(character),
            apiService.fetchTalentAscensionMaterials(character)
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<dynamic> results = snapshot.data ?? [];

              Widget imageWidget, visionWidget;

              if (results[0] != null && results[0].isNotEmpty) {
                imageWidget = Image.network(
                  results[0],
                  width: 400,
                  height: 400,
                );
              } else {
                imageWidget = Image.asset(
                  'assets/portrait_empty.png',
                  width: 400,
                  height: 400,
                );
              }

              if (results[1] != null && results[1].isNotEmpty) {
                visionWidget = Image.network(
                  results[1],
                  width: 50,
                  height: 50,
                );
              } else {
                visionWidget = Image.asset(
                  'assets/portrait_empty.png',
                  width: 50,
                  height: 50,
                );
              }

              final Map<String, dynamic> ascensionMaterials =
                  results[2] as Map<String, dynamic>? ?? {};

              final Map<String, String> bossMaterial =
                  results[3] as Map<String, String>? ?? {};

              final Map<String, String> localMaterial =
                  results[4] as Map<String, String>? ?? {};

              final Map<String, dynamic> commonMaterial =
                  results[5] as Map<String, dynamic>? ?? {};

              final Map<String, String> weeklyBossMaterial =
                  results[6] as Map<String, String>? ?? {};

              final Map<String, dynamic> talentMaterial =
                  results[7] as Map<String, dynamic>? ?? {};

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    imageWidget,
                    SizedBox(height: 5),
                    Text(
                      character.toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Genshin',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff002c58),
                      ),
                    ),
                    SizedBox(height: 10),
                    visionWidget,
                    SizedBox(height: 10),
                    Container(
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                          color: getVisionColor(vision),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          buildAscensionMaterialRow(
                              'Sliver', ascensionMaterials['sliver'] ?? {}),
                          buildAscensionMaterialRow(
                              'Fragment', ascensionMaterials['fragment'] ?? {}),
                          buildAscensionMaterialRow(
                              'Chunk', ascensionMaterials['chunk'] ?? {}),
                          buildAscensionMaterialRow(
                              'Gemstone', ascensionMaterials['gemstone'] ?? {}),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: getVisionColor(vision),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildBossMaterialRow(bossMaterial),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: getVisionColor(vision),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildLocalMaterialRow(localMaterial),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: getVisionColor(vision),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 40, // Set a minimum height if needed
                            ),
                            child: buildCommonMaterialRow(commonMaterial),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 50,
                        width: 350,
                        decoration: BoxDecoration(
                          color: getVisionColor(vision),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildWeeklyBossMaterialRow(weeklyBossMaterial),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: getVisionColor(vision),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 40,
                            ),
                            child: buildTalentMaterialRow(talentMaterial),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
