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
                return Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://genshin.jmp.blue/characters/$characterName/card', // Use big icon URL
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          capitalize(characterName),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
