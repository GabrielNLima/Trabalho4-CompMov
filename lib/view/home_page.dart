import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trab3/helpers/game_helper.dart';
import 'package:trab3/view/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameHelper helper = GameHelper();
  List<dynamic> games = [];

  @override
  void initState() {
    super.initState();
    getAllGames();
  }

  void getAllGames() {
    helper.getAllGames().then((list) {
      setState(() {
        games = list;
      });
    });
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
      ),
      backgroundColor: const Color.fromARGB(255, 112, 13, 129),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showGamePage();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return gameCard(context, index);
        },
      ),
    );
  }

  Widget gameCard(BuildContext context, int index) {
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
                      "${games[index].name}",
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 112, 13, 129),
                      ),
                    ),
                    Text(
                      "Gênero: ${games[index].genre}",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Horas Jogadas: ${games[index].hours}",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Rating: ${games[index].rating?.toStringAsFixed(1)}", // Exibe o Rating
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Data de Compra: ${games[index].purchaseDate}",
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
        showOptions(context, index);
      },
    );
  }

  void showGamePage({Game? game}) async {
    final recGame = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(game: game),
      ),
    );
    if (recGame != null) {
      if (game != null) {
        await helper.updateGame(recGame);
      } else {
        await helper.saveGame(recGame);
      }
      getAllGames();
    }
  }

  void showOptions(BuildContext context, int index){
    showModalBottomSheet(context: context,
    builder: (context){
      return BottomSheet(
        onClosing: () {},
        builder:(context) {
         return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: const Text("Editar",
                style: TextStyle(color: Color.fromARGB(255, 112, 13, 129), fontSize: 20.0 )),
                onPressed: () {
                  Navigator.pop(context);
                  showGamePage(game: games[index]);
                },
              ),
              TextButton(
                child: const Text("Excluir",
                style: TextStyle(color: Colors.red, fontSize: 20.0 )),
                onPressed: () {
                  requestPop(index);
                },
              ),
            ],
          ),
         ); 
        });
    });
  }

  Future<bool> requestPop(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Jogo?"),
          content: const Text("Essa ação não pode ser desfeita."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                helper.deleteGame(games[index]);
                setState(() {
                  games.removeAt(index);
                  Navigator.pop(context);
                });
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
