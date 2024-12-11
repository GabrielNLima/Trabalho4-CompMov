import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/auth_page.dart';

class AuthService {
  void userRegister(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
  ) async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorAlert(context, "Todos os campos são obrigatórios");
    } else if (passwordController.text != confirmPasswordController.text) {
      showErrorAlert(context, "As senhas não conferem");
    } else {
      // showLoadingAlert(context);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = "A senha fornecida é muito fraca. Tente uma senha mais forte.";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "Este email já está em uso. Tente outro.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "O formato do email é inválido. Verifique o email.";
        } else {
          errorMessage = "Erro desconhecido: ${e.message}";
        }

        showErrorAlert(context, errorMessage);
      }
    }
  }

  void showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 112, 13, 129)),
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  // Função para mostrar o alerta de carregamento
  void showLoadingAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Carregando..."),
          content: CircularProgressIndicator(),
        );
      },
    );
  }
}