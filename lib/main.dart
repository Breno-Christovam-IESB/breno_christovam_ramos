import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'views/home_page.dart';

// Função principal da aplicação, que é o ponto de entrada do aplicativo.
void main() {
  // Verifica se a aplicação não está rodando na web.
  if (!kIsWeb) {
    // Inicializa a configuração FFI para o banco de dados SQLite se não estiver na web.
    sqfliteFfiInit();
  }
  // Executa a aplicação e inicia o widget MyApp.
  runApp(MyApp());
}

// Classe MyApp que define a configuração principal do aplicativo.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retorna um widget MaterialApp que configura o tema e a tela inicial do aplicativo.
    return MaterialApp(
      // Define o título do aplicativo.
      title: 'Controle do Boletim Acadêmico',
      // Configura o tema do aplicativo.
      theme: ThemeData(
        // Define a cor primária do tema como azul.
        primarySwatch: Colors.blue,
      ),
      // Define a tela inicial do aplicativo como HomePage.
      home: HomePage(),
    );
  }
}