import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../styles/color.dart';
import 'details.dart'; // Make sure this import points to your CharactersDetailsPage correctly

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> favoriteCharacters = [];
  TextEditingController searchController = TextEditingController();
  bool userNotFound = false; // Flag to indicate if user was not found
  String? searchMessage; // Optional message based on search result

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }
  Future<String?> fetchUsername(String userId) async {
    // Fetch the username using the user's UID
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data()!.containsKey('username')) {
      return userDoc.data()!['username'] as String?;
    }
    return null;
  }

  void fetchFavorites([String? searchUsername]) async {
    setState(() {
      favoriteCharacters.clear(); // Clear favorites before fetching new ones
      userNotFound = false; // Reset user not found flag
      searchMessage = null; // Reset search message
    });

    String? username;
    if (searchUsername != null && searchUsername.isNotEmpty) {
      // Attempt to fetch user document by username
      
      final usernameExists = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: searchUsername)
          .get()
          .then((snapshot) => snapshot.docs.isNotEmpty);

      if (!usernameExists) {
        setState(() {
          userNotFound = true;
          searchMessage = "User does not exist";
        });
        print('lol');
        return;
      }
      print('lo');
      username = searchUsername;
    } else {
      var user = _auth.currentUser;
      if (user != null) {
        username = await fetchUsername(user.uid);
      }
    }

    if (username != null) {
      final QuerySnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('usernameData')
          .doc(username)
          .collection('favorites')
          .get();

      if (favoriteSnapshot.docs.isEmpty) {
        setState(() {
          searchMessage = searchUsername != null && searchUsername.isNotEmpty
              ? "$username has no favorites yet"
              : "You have no favorites yet";
        });
      } else {
        final List<Map<String, dynamic>> fetchedFavorites = favoriteSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          favoriteCharacters = fetchedFavorites;
        });
      }
    }
  }

  void handleSearch() {
    fetchFavorites(searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search other users\' favorites',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: handleSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: userNotFound || favoriteCharacters.isEmpty
                ? Center(
                    child: Text(
                      searchMessage ?? 'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff002c58),
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: favoriteCharacters.length,
                    itemBuilder: (context, index) {
                      final character = favoriteCharacters[index];
                      final characterName = character['character'];
                      final vision = character['vision'];
                      return buildCharacterCard(context, characterName, vision);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildCharacterCard(BuildContext context, String characterName, String vision) {
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
                'https://genshin.jmp.blue/characters/$characterName/card',
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
  }

  String capitalize(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }
}
