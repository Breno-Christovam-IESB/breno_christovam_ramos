import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/disciplina_store.dart';
import '../stores/nota_store.dart';
import '../models/disciplina.dart';

// Define a classe `RelatorioPage` como um widget estático.
class RelatorioPage extends StatelessWidget {
  // Inicializa o `DisciplinaStore` para gerenciar as disciplinas.
  final disciplinaStore = DisciplinaStore();
  // Inicializa o `NotaStore` para gerenciar as notas.
  final notaStore = NotaStore();

  @override
  Widget build(BuildContext context) {
    // Carrega as disciplinas ao construir a página.
    disciplinaStore.loadDisciplinas();

    // Define a estrutura visual da página.
    return Scaffold(
      // Define a barra de aplicativo no topo da página.
      appBar: AppBar(
        // Define o título da barra de aplicativo.
        title: Text('Relatório de Aprovação'),
      ),
      // Define o corpo da página usando um `Observer` para observar mudanças no estado.
      body: Observer(
        // Builder que constrói a interface com base no estado observado.
        builder: (_) => ListView.builder(
          // Define o número de itens na lista com base na quantidade de disciplinas.
          itemCount: disciplinaStore.disciplinas.length,
          // Constrói o widget para cada item da lista.
          itemBuilder: (context, index) {
            // Obtém a disciplina atual da lista de disciplinas.
            final disciplina = disciplinaStore.disciplinas[index];
            // Usa um FutureBuilder para calcular a média de notas da disciplina.
            return FutureBuilder(
              // Define o futuro que calcula a média.
              future: _calcularMedia(disciplina),
              // Define a função a ser chamada para construir o widget com base no resultado do futuro.
              builder: (context, snapshot) {
                // Verifica se os dados ainda não foram carregados.
                if (!snapshot.hasData) {
                  // Exibe um ListTile com uma mensagem de "Calculando..." enquanto os dados estão carregando.
                  return ListTile(
                    title: Text(disciplina.nome),
                    subtitle: Text('Calculando...'),
                  );
                }

                // Obtém a média calculada do snapshot de dados.
                final media = snapshot.data as double;
                // Determina se o aluno foi aprovado com base na média (>= 5.0).
                final aprovado = media >= 5.0;

                // Retorna um ListTile com o nome da disciplina, a média e o status de aprovação.
                return ListTile(
                  title: Text(disciplina.nome),
                  subtitle: Text('Média: $media'),
                  trailing: Text(aprovado ? 'Aprovado' : 'Reprovado'),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Método para calcular a média das notas de uma disciplina.
  Future<double> _calcularMedia(Disciplina disciplina) async {
    // Carrega as notas para a disciplina fornecida.
    await notaStore.loadNotas(disciplina.id);

    // Verifica se não há notas disponíveis.
    if (notaStore.notas.isEmpty) return 0.0;

    // Filtra as notas para a disciplina específica e calcula a soma das notas.
    final notas = notaStore.notas.where((nota) => nota.disciplinaId == disciplina.id).toList();
    final totalNotas = disciplina.isAnual ? 4 : 2; // Define o número total de notas com base se a disciplina é anual ou semestral.
    final somaNotas = notas.fold(0.0, (sum, nota) => sum + nota.nota); // Soma todas as notas.
    return somaNotas / totalNotas; // Calcula e retorna a média das notas.
  }
}