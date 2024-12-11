import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trab4/service/game_service.dart';
import 'package:trab4/view/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GameService _gameService = GameService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getGames() {
    final userId = _auth.currentUser?.uid;

    return _firestore
        .collection('games')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/jogo.png',
              fit: BoxFit.contain,
              height: 45,
              width: 45,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 112, 13, 129)),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 112, 13, 129),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePage(gameId: ''),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _gameService
                  .readGames(FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum jogo encontrado.'));
                }

                final games = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return gameCard(context, index, games);
                  },
                );
                // return ListView.builder(
                //   itemCount: games.length,
                //   itemBuilder: (context, index) {
                //     final game = games[index];
                //     final docId = game.id;
                //     final name = game['name'];
                //     final genre = game['genre'];
                //     final hours = game['hours'];
                //     final rating = game['rating'];
                //     final purchaseDate = game['purchaseDate'];

                //     return ListTile(
                //       title: Text('$name'),
                //       trailing: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           IconButton(
                //             icon: Icon(Icons.edit),
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) =>
                //                       GamePage(gameId: docId),
                //                 ),
                //               );
                //             },
                //           ),
                //           IconButton(
                //             icon: Icon(Icons.delete),
                //             onPressed: () {
                //               _deleteGame(docId);
                //             },
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget gameCard(BuildContext context, int index, List games) {
    final game = games[index];
    final docId = game.id;
    final name = game['name'];
    final genre = game['genre'];
    final hours = game['hours'];
    final rating = game['rating'];
    final purchaseDate = game['purchaseDate'];
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$name",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 112, 13, 129),
                      ),
                    ),
                    Text(
                      "Gênero: $genre",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Horas Jogadas: $hours",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Rating: ${rating?.toStringAsFixed(1)}", // Exibe o Rating
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Data de Compra: $purchaseDate",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showOptions(context, index, docId);
      },
    );
  }

  void showOptions(BuildContext context, int index, String docId){
    showModalBottomSheet(context: context,
    builder: (context){
      return BottomSheet(
        onClosing: () {},
        builder:(context) {
         return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: const Text("Editar",
                style: TextStyle(color: Color.fromARGB(255, 112, 13, 129), fontSize: 20.0 )),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GamePage(gameId: docId),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text("Excluir",
                style: TextStyle(color: Colors.red, fontSize: 20.0 )),
                onPressed: () {
                  _deleteGame(docId);
                },
              ),
            ],
          ),
         ); 
        });
    });
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }

  Future<void> _deleteGame(String docId) async {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Excluir Jogo?"),
            content: const Text("Essa ação não pode ser desfeita."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _gameService.deleteGame(docId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jogo excluído com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text("Sim"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    }
}
