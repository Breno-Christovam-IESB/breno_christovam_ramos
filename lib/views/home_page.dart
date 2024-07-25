import 'package:flutter/material.dart';
import 'disciplina_page.dart';
import 'relatorio_page.dart';
import 'nota_page.dart';
import '../stores/disciplina_store.dart';
import '../stores/nota_store.dart';

class HomePage extends StatelessWidget {
  final disciplinaStore = DisciplinaStore(); // Inicialize seu store
  final notaStore = NotaStore(); // Inicialize seu store

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Boletim Acadêmico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisciplinaPage()),
                );
              },
              child: Text('Cadastro de Disciplinas'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar para a NotaPage (Você pode querer selecionar uma disciplina primeiro)
                disciplinaStore.loadDisciplinas().then((_) {
                  if (disciplinaStore.disciplinas.isNotEmpty) {
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
                    // Se não houver disciplinas, você pode mostrar uma mensagem ou outra página
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nenhuma disciplina encontrada')),
                    );
                  }
                });
              },
              child: Text('Lançamento de Notas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RelatorioPage()),
                );
              },
              child: Text('Relatório de Aprovação'),
            ),
          ],
        ),
      ),
    );
  }
}