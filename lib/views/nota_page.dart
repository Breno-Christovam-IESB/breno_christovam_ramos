import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/nota_store.dart';
import '../models/nota.dart';
import '../models/disciplina.dart';

class NotaPage extends StatelessWidget {
  final Disciplina disciplina;
  final NotaStore notaStore;

  NotaPage({required this.disciplina, NotaStore? notaStore})
      : notaStore = notaStore ?? NotaStore(); // Usar NotaStore padrão se não fornecido

  @override
  Widget build(BuildContext context) {
    notaStore.loadNotas(disciplina.id);

    final _notaController = TextEditingController();
    int _bimestre = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lançamento de Notas - ${disciplina.nome}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _notaController,
              decoration: InputDecoration(labelText: 'Nota'),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              value: _bimestre,
              onChanged: (value) {
                if (value != null) {
                  _bimestre = value;
                }
              },
              items: List.generate(disciplina.isAnual ? 4 : 2, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('Bimestre ${index + 1}'),
                );
              }),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final notaText = _notaController.text;
              if (notaText.isNotEmpty) {
                try {
                  final novaNota = Nota(
                    id: 0,
                    disciplinaId: disciplina.id,
                    nota: double.parse(notaText),
                    bimestre: _bimestre,
                    descricao: 'Descrição da Nota', // Fornecendo a descrição
                    valor: double.parse(notaText), // Fornecendo o valor
                  );
                  notaStore.addNota(novaNota);
                  Navigator.pop(context);
                } catch (e) {
                  // Adicionar tratamento de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar nota: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Por favor, insira uma nota.')),
                );
              }
            },
            child: Text('Adicionar Nota'),
          ),
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                itemCount: notaStore.notas.length,
                itemBuilder: (context, index) {
                  final nota = notaStore.notas[index];
                  return ListTile(
                    title: Text('Bimestre ${nota.bimestre}: ${nota.nota}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        notaStore.removeNota(nota.id, disciplina.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}