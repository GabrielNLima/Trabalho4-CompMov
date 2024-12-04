// import 'package:auth/view/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trab4/components/my_button.dart';
import 'package:trab4/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void showAlert(String message){
    showDialog(context: context,
      builder: (context){
        return AlertDialog(title: Text(message));
    });
  }
  
  void registerUser() async{
    showDialog(
      context: context, 
      builder: (context){
        return const Center(child: CircularProgressIndicator());
      }
    );

    // try{
    //   if(passwordController.text == confirmpasswordController.text){
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: userNameController.text, 
    //       password: passwordController.text);
    //     Navigator.pop(context);
    //     showAlert("Usuário cadastrado com Sucesso!");
    //     Navigator.push(context, MaterialPageRoute(
    //       builder: (context)=> LoginPage()));        
    //   }else{
    //     Navigator.pop(context);
    //     showAlert("Senhas não conferem!");
    //   }

    // }on FirebaseAuthException catch (e){
    //   print(e.code);
    //   if(e.code == 'email-already-in-use'){
    //     Navigator.pop(context);
    //     showDialog(context: context, builder: (context){
    //       return const AlertDialog(title: Text('Já existe um usuário com esse email!'));
    //     });
    //   }
    // }

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
                Text("Crie seu Cadastro!",
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 25.0, 
                  fontWeight: FontWeight.bold),),
                const SizedBox(height: 25.0),
                MyTextfield(controller: userNameController, 
                hintText: "Email", 
                obscureText: false),

                const SizedBox(height: 15),
                MyTextfield(controller: passwordController, 
                hintText: "Senha", 
                obscureText: true),

                const SizedBox(height: 15),
                MyTextfield(controller: confirmpasswordController, 
                hintText: "Confirme sua Senha", 
                obscureText: true),

                const SizedBox(height: 25.0),
                
                MyButton(
                  onTap: registerUser,
                  text: "Cadastrar!",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}