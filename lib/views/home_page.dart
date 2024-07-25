import 'package:flutter/material.dart';
import 'disciplina_page.dart';
import 'relatorio_page.dart';
import 'nota_page.dart';
import '../stores/disciplina_store.dart';
import '../stores/nota_store.dart';

// Define a classe `HomePage` como um widget estático.
class HomePage extends StatelessWidget {
  // Cria uma instância de `DisciplinaStore`, que gerencia o estado das disciplinas.
  final disciplinaStore = DisciplinaStore(); // Inicialize seu store

  // Cria uma instância de `NotaStore`, que gerencia o estado das notas.
  final notaStore = NotaStore(); // Inicialize seu store

  @override
  Widget build(BuildContext context) {
    // Define a estrutura visual da página.
    return Scaffold(
      // Define a barra de aplicativo no topo da página.
      appBar: AppBar(
        // Define o título da barra de aplicativo.
        title: Text('Controle de Boletim Acadêmico'),
      ),
      // Define o corpo da página.
      body: Center(
        child: Column(
          // Centraliza os widgets filhos verticalmente.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Botão para navegação para a página de cadastro de disciplinas.
            ElevatedButton(
              onPressed: () {
                // Navega para a página de cadastro de disciplinas quando o botão é pressionado.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisciplinaPage()),
                );
              },
              // Texto exibido no botão.
              child: Text('Cadastro de Disciplinas'),
            ),
            // Botão para navegação para a página de lançamento de notas.
            ElevatedButton(
              onPressed: () {
                // Carrega as disciplinas e navega para a página de lançamento de notas.
                disciplinaStore.loadDisciplinas().then((_) {
                  // Verifica se há disciplinas carregadas.
                  if (disciplinaStore.disciplinas.isNotEmpty) {
                    // Navega para a página de notas com a primeira disciplina.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotaPage(
                          disciplina: disciplinaStore.disciplinas[0], // Exemplo: Usar a primeira disciplina
                          notaStore: notaStore,
                        ),
                      ),
                    );
                  } else {
                    // Se não houver disciplinas, exibe uma mensagem de erro.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nenhuma disciplina encontrada')),
                    );
                  }
                });
              },
              // Texto exibido no botão.
              child: Text('Lançamento de Notas'),
            ),
            // Botão para navegação para a página de relatório de aprovação.
            ElevatedButton(
              onPressed: () {
                // Navega para a página de relatório de aprovação quando o botão é pressionado.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelatorioPage()),
                );
              },
              // Texto exibido no botão.
              child: Text('Relatório de Aprovação'),
            ),
          ],
        ),
      ),
    );
  }
}