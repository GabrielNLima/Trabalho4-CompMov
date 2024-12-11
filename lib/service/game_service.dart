import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  bool _isRatingValido(double rating) {
    return rating >= 0 && rating <= 10;
  }

  Future<void> createGame({
    required String name,
    required String genre,
    required String hours,  
    required double rating,
    required String purchaseDate,
    required String userId,

  }) { 
    if (name.isEmpty || genre.isEmpty || hours.isEmpty || purchaseDate.isEmpty || rating.isNaN) {
      throw Exception("Todos os campos são obrigatórios.");
    }

    if (!_isRatingValido(rating)) {
      throw Exception("A avaliação deve ser entre 0 e 10.");
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
    double? rating,
    String? purchaseDate,
  }) {
    Map<String, dynamic> updatedGame = {};
    if (name != null && name.isNotEmpty) {
      updatedGame['name'] = name;
    }
    if (genre != null && genre.isNotEmpty) {
      updatedGame['genre'] = genre;
    }
    if (hours != null && hours.isNotEmpty) {
      updatedGame['hours'] = hours;
    }
    if (rating != null && rating.isNaN) {
      updatedGame['rating'] = rating;
    }
    if (purchaseDate != null && purchaseDate.isNotEmpty) {
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