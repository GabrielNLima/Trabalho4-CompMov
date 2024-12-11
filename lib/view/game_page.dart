import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trab4/service/game_service.dart';

class GamePage extends StatefulWidget {
  final String gameId;

  GamePage({required this.gameId});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameService _gameService = GameService();
  final  _nameController = TextEditingController();
  final  _genreController = TextEditingController();
  final  _ratingController = TextEditingController();
  final  _hoursController = TextEditingController();
  final  _dateController = TextEditingController();

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
      _hoursController.text = gameData['hours'];
      _ratingController.text = gameData['rating'].toString();
      _dateController.text = gameData['purchaseDate'];
    });
  } catch (e) {
    print("Erro ao carregar dados do game: $e");
  }
}

  Future<void> _saveGame() async {
  final String name = _nameController.text.trim();
  final String genre = _genreController.text.trim();
  final String hours = _hoursController.text.trim();
  final double rating = double.tryParse(_ratingController.text) ?? 0;
  final String purchaseDate = _dateController.text.trim();

  if (name.isEmpty || genre.isEmpty || rating <= 0.0 || purchaseDate.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos corretamente.')),
    );
    return;
  }
  if (rating < 0.0 || rating > 10.0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('O campo Rating deve estar entre 0.0 e 10.0',)),
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
    print('Erro ao salvar Jogo: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar o jogo: $e')),
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
      _dateController.clear();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 112, 13, 129),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(_editingGameId == null ? 'Adicionar Jogo' : 'Editar Jogo', style: const TextStyle(color: Color.fromARGB(255, 112, 13, 129))),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveGame,
          backgroundColor: Colors.white,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Nome",
                ),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _genreController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Gênero",
                ),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _hoursController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Horas Jogadas",
                ),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Rating (0-10)",
                ),
                onChanged: (text) {
                  _userEdited = true;
                },
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "Data de Compra",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar alterações?"),
            content: const Text("Se sair, as alterações serão perdidas."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
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
    } else {
      return Future.value(true);
    }
  }
  
}