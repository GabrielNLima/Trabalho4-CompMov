import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final CollectionReference carrosCollection =
      FirebaseFirestore.instance.collection('carros');

  Future<void> createGame({
    required String name,
    required String genre,
    required String hours,
    required String rating,
    required DateTime purchaseDate,
    required String userId,
  }) { 
    if (name.isEmpty || genre.isEmpty || hours.isEmpty || rating.isEmpty) {
      throw Exception("Todos os campos são obrigatórios.");
    }

    return gamesCollection.add({
      'name': name,
      'genre' : genre,
      'hours' : hours,
      'rating' : rating,
      'purchaseDate' : purchaseDate,
      'userId': userId,
    });
  }

  Stream<QuerySnapshot> readGames(String userId) {
    return gamesCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Future<void> updateGame({
    required String docId,
    String? name,
    String? genre,
    String? hours,
    String? rating,
    DateTime? purchaseDate,
  }) {
    Map<String, dynamic> updatedGame = {};
    if (name != null && name.isNotEmpty) {
      updatedGame['name'] = name;
    }
    if (genre != null && genre.isNotEmpty) {
      updatedGame['genre'] = genre;
    }
    if (hours != null) {
      updatedGame['hours'] = hours;
    }
    if (rating != null && rating.isNotEmpty) {
      updatedGame['rating'] = rating;
    }
    if (purchaseDate != null) {
      updatedGame['purchaseDate'] = purchaseDate;
    }
    return gamesCollection.doc(docId).update(updatedGame);
  }

  Future<Map<String, dynamic>> getGame(String docId) async {
    DocumentSnapshot doc = await gamesCollection.doc(docId).get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> deleteGame(String docId) {
    return gamesCollection.doc(docId).delete();
  }
}