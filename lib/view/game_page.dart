import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trab4/service/files_store_service.dart';

class GamePage extends StatefulWidget {
  final String gameId;

  GamePage({required this.gameId});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameService _gameService = GameService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();

  String? _editingGameId;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.gameId.isNotEmpty) {
      _loadGameData(widget.gameId);
    }
  }
  Future<String?> getCurrentUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  print(user?.uid);
  return user?.uid;
}

  Future<void> _loadGameData(String gameId) async {
  try {
    final gameData = await _gameService.getGame(gameId);
    setState(() {
      _editingGameId = gameId;
      _nameController.text = gameData['name'];
      _genreController.text = gameData['genre'];
      _ratingController.text = gameData['hours'];
      _hoursController.text = gameData['cor'];
      _purchaseDateController.text = gameData['purchaseDate'];
    });
  } catch (e) {
    print("Erro ao carregar dados do game: $e");
  }
}

  Future<void> _saveGame() async {
  final String name = _nameController.text.trim();
  final String genre = _genreController.text.trim();
  final String hours = _hoursController.text.trim();
  final String rating = _hoursController.text.trim();
  final String purchaseDate = _purchaseDateController.text.trim();

  if (name.isEmpty || genre.isEmpty || rating.isEmpty || hours <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos corretamente.')),
    );
    return;
  }

  try {
    final String? userId = await getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: Usuário não autenticado.')),
      );
      return;
    }

    if (_editingGameId == null) {
      await _gameService.createGame(
        name: name,
        genre: genre,
        hours: hours,
        rating: rating,
        purchaseDate: purchaseDate,
        userId: userId,
      );
    } else {
      await _gameService.updateGame(
        docId: _editingGameId!,
        name: name,
        genre: genre,
        hours: hours,
        rating: rating,
        purchaseDate: purchaseDate,
      );
    }

    _clearFields();
    Navigator.pop(context);
  } catch (e) {
    print('Erro ao salvar game: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar o game: $e')),
    );
  }
}
  void _clearFields() {
    setState(() {
      _editingGameId = null;
      _nameController.clear();
      _genreController.clear();
      _ratingController.clear();
      _hoursController.clear();
      _purchaseDateController.clear();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
    onWillPop: requestPop,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_editingGameId == null ? 'Adicionar Game' : 'Editar Game', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (text) {
                _userEdited = true;
              },
            ),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(labelText: 'Genre'),
              onChanged: (text) {
                _userEdited = true;
              },
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                _userEdited = true;
              },
            ),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: 'Hours'),
              onChanged: (text) {
                _userEdited = true;
              },
            ),
            TextField(
              controller: _purchaseDateController,
              decoration: InputDecoration(labelText: 'PurchaseDate'),
              onChanged: (text) {
                _userEdited = true;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGame,
              child: Text('Salvar', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    ),
  );
  }
  Future<bool> requestPop() async {
    if (_userEdited) {
      bool shouldLeave = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar Alterações"),
            content: const Text(
                "Se sair, as alterações serão perdidas. Deseja continuar?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Sim"),
              ),
            ],
          );
        },
      );

      return Future.value(shouldLeave ?? false);
    } else {
      return Future.value(true);
    }
  }
  
}