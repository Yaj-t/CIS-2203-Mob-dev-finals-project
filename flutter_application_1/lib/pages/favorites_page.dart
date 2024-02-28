import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles/color.dart';
import 'details.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> favoriteCharacters = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  void fetchFavorites() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .get();

      final List<Map<String, dynamic>> fetchedFavorites = favoriteSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (mounted) {
        setState(() {
          favoriteCharacters = fetchedFavorites;
        });
      }
    }
  }

  String capitalize(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E1),
      body: favoriteCharacters.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust number of columns
                childAspectRatio: 0.75, // Adjust child aspect ratio
              ),
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                
                final character = favoriteCharacters[index];
                final characterName = character['character'];
                final vision = character['vision']; // Assuming 'vision' is part of your character map

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharactersDetailsPage(
                          character: characterName,
                          vision: vision,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    color: getVisionColor(vision),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://genshin.jmp.blue/characters/$characterName/card', // Use card URL
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            capitalize(characterName),
                            style: TextStyle(
                              fontFamily: 'Genshin',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff002c58),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
