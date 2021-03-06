import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/mensagem.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  bool isLoading = false;

  @override

  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: Image.asset('lib/imagens/logoapp_q.png',), 
        title: const Text('FiscalNews'),
      ),


      backgroundColor: Colors.white,

      body: Container(
        padding: const EdgeInsets.all(50),

        child: ListView(
          children: [
            campoTexto('Email', txtEmail, Icons.email),
            const SizedBox(height: 20),
            campoTexto('Senha', txtSenha, Icons.lock, senha: true),
            const SizedBox(height: 40),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                minimumSize: const Size(200, 45),
                backgroundColor: Colors.black,
              ),
              child: const Text('entrar'),
              onPressed: () {
                login(txtEmail.text, txtSenha.text);
              },
            ),
            const SizedBox(height: 50),
            TextButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
              ),
              child: const Text('Criar conta'),
              onPressed: () {
                Navigator.pushNamed(context, 'Cadastro');
              },
            ),
          ],
        ),
      ),
    );
  }

  //
  // CAMPO DE TEXTO
  //
  campoTexto(texto, controller, icone, {senha}) {
    return TextField(
      controller: controller,
      obscureText: senha != null ? true : false,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icone, color: Colors.black),
        prefixIconColor: Colors.black,
        labelText: texto,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 0.0,
          ),
        ),
      ),
    );
  }

  //
  // LOGIN com Firebase Auth
  //
  void login(email, senha) {
    FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: senha)
      
      //Se login deu certo
      .then((res) {        
        sucesso(context, "Usuario autenticado com sucesso.");
        Navigator.pushReplacementNamed(context, 'Feed');
      })
      
      //Se login deu errado
      .catchError((e){
        switch(e.code){
          case 'invalid-email':
            erro(context,'O formato do email ?? inv??lido.');
            break;
          case 'user-not-found':
            erro(context,'Usu??rio n??o encontrado.');
            break;
          case 'wrong-password':
            erro(context,'Senha incorreta.');
            break;
          default:
            erro(context,e.code.toString());
        }
      });


  
  }
}
