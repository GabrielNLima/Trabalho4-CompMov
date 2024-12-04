import 'package:flutter/widgets.dart';
import 'package:trab4/service/files_store_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService service = FirestoreService();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}