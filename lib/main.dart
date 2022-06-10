import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'views/login_page.dart';
import 'views/tela_listafavoritos.dart';
import 'views/criar_conta_page.dart';
import 'views/tela_principal.dart';
import 'views/tela_lista.dart';
import 'views/tela_sobre.dart';
import 'views/tela_bancas.dart';
import 'views/inserir_favoritos.dart';

Future<void> main() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FiscalNews',
      initialRoute: 'Login',

      routes: {
        'Login': (context) => const LoginPage(),
        'Cadastro': (context) => const CriarContaPage(),
        'Feed': (context) => const TelaPrincipal(),
        'Lista': (context) => const TelaLista(),
        'Bancas': (context) => const TelaBancas(),
        'Sobre': (context) => const TelaSobre(),
        'Favoritar': (context) => const InserirFavorito(),
        'Favoritos': (context) => const ListaFavorito(),
      },
    )
  );
}


