import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trab4/components/my_button.dart';
import 'package:trab4/components/my_textfield.dart';
import 'package:trab4/view/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(child: CircularProgressIndicator());
    //   },
    // );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text,
        password: passwordController.text
      );
      Navigator.pop(context);
    }on FirebaseAuthException catch(e) {
      print(e.code);
      if(e.code == 'invalid-credential') {
        // Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text('Usuário ou senha Incorretas'));
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 112, 13, 129),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0),
                Image.asset(
                  'assets/imgs/jogo.png', 
                  fit: BoxFit.contain, 
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 50.0),
                const Text(
                  'Seja Bem Vindo(a)',
                  style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25.0),
                MyTextfield(
                  controller: userNameController, 
                  hintText: "E-mail", 
                  obscureText: false),
                const SizedBox(height: 15.0),
                MyTextfield(
                  controller: passwordController, 
                  hintText: "Senha", 
                  obscureText: true),
                const SizedBox(height: 15.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Esqueceu a Senha?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                MyButton(onTap: signUserIn, text: "Entrar"),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem Cadastro?",
                    style: TextStyle(color: Color.fromARGB(255, 209, 209, 209)),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>
                        const RegisterPage(),)
                        );
                      },
                      child: const Text("Registre-se Agora!",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ))
    );
  }
}