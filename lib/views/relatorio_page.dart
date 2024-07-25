import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/disciplina_store.dart';
import '../stores/nota_store.dart';
import '../models/disciplina.dart';

class RelatorioPage extends StatelessWidget {
  final disciplinaStore = DisciplinaStore();
  final notaStore = NotaStore();

  @override
  Widget build(BuildContext context) {
    disciplinaStore.loadDisciplinas();

    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Aprovação'),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: disciplinaStore.disciplinas.length,
          itemBuilder: (context, index) {
            final disciplina = disciplinaStore.disciplinas[index];
            return FutureBuilder(
              future: _calcularMedia(disciplina),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListTile(
                    title: Text(disciplina.nome),
                    subtitle: Text('Calculando...'),
                  );
                }

                final media = snapshot.data as double;
                final aprovado = media >= 5.0;

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

  Future<double> _calcularMedia(Disciplina disciplina) async {
    await notaStore.loadNotas(disciplina.id);

    if (notaStore.notas.isEmpty) return 0.0;

    final notas = notaStore.notas.where((nota) => nota.disciplinaId == disciplina.id).toList();
    final totalNotas = disciplina.isAnual ? 4 : 2;
    final somaNotas = notas.fold(0.0, (sum, nota) => sum + nota.nota);
    return somaNotas / totalNotas;
  }
}