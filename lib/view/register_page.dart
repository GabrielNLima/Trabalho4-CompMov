import 'package:flutter/material.dart';
import 'package:trab4/components/my_button.dart';
import 'package:trab4/components/my_textfield.dart';
import 'package:trab4/view/login_page.dart';
import '../service/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    void registerUserIn() async {
      AuthService().userRegister(
        context,
        emailController,
        passwordController,
        confirmPasswordController,
      );
    }
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
                  controller: emailController, 
                  hintText: "E-mail", 
                  obscureText: false),
                const SizedBox(height: 15.0),
                MyTextfield(
                  controller: passwordController, 
                  hintText: "Senha", 
                  obscureText: true),
                const SizedBox(height: 15.0),
                MyTextfield(
                  controller: confirmPasswordController, 
                  hintText: "Confirmar Senha", 
                  obscureText: true),
                const SizedBox(height: 25.0),
                MyButton(onTap: registerUserIn, text: "Registrar"),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Já tem Cadastro?",
                    style: TextStyle(color: Color.fromARGB(255, 209, 209, 209)),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>
                        LoginPage(),)
                        );
                      },
                      child: const Text("Entre Agora!",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}