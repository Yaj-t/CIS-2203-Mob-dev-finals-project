import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleFavorite(String characterName) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentReference favoritesRef = _firestore
        .collection('favorites')
        .doc(user.uid);

    DocumentSnapshot snapshot = await favoritesRef.get();
    if (snapshot.exists) {
      if (snapshot['favorites'].contains(characterName)) {
        favoritesRef.update({
          'favorites': FieldValue.arrayRemove([characterName])
        });
      } else {
        favoritesRef.update({
          'favorites': FieldValue.arrayUnion([characterName])
        });
      }
    } else {
      favoritesRef.set({'favorites': [characterName]});
    }
  }

  Future<List<String>> getFavorites() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    DocumentSnapshot snapshot =
        await _firestore.collection('favorites').doc(user.uid).get();

    if (snapshot.exists && snapshot.data() is Map) {
      final data = snapshot.data() as Map;
      return List<String>.from(data['favorites']);
    }
    return [];
  }

  Stream<List<String>> getFavoritesStream() {
    User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('favorites')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() is Map) {
        final data = snapshot.data() as Map;
        return List<String>.from(data['favorites']);
      }
      return [];
    });
  }
}
