import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/disciplina_store.dart';
import '../models/disciplina.dart';
import 'nota_page.dart';
import '../stores/nota_store.dart';

class DisciplinaPage extends StatelessWidget {
  final disciplinaStore = DisciplinaStore();
  final notaStore = NotaStore(); // Criar uma instância de NotaStore
  final _nomeController = TextEditingController();
  bool _isAnual = false;

  @override
  Widget build(BuildContext context) {
    // Recarregar disciplinas ao entrar na página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      disciplinaStore.loadDisciplinas();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Disciplina'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Disciplina'),
            ),
          ),
          SwitchListTile(
            title: Text('Curso Anual'),
            value: _isAnual,
            onChanged: (value) {
              _isAnual = value;
            },
          ),
          ElevatedButton(
            onPressed: () {
              final novaDisciplina = Disciplina(
                id: 0, // ID será gerado pelo banco de dados
                nome: _nomeController.text,
                isAnual: _isAnual,
              );
              disciplinaStore.addDisciplina(novaDisciplina);
              Navigator.pop(context); // Voltar para a tela anterior
            },
            child: Text('Adicionar Disciplina'),
          ),
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                itemCount: disciplinaStore.disciplinas.length,
                itemBuilder: (context, index) {
                  final disciplina = disciplinaStore.disciplinas[index];
                  return ListTile(
                    title: Text(disciplina.nome),
                    subtitle: Text(disciplina.isAnual ? 'Anual' : 'Semestral'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotaPage(
                            disciplina: disciplina,
                            notaStore: notaStore,
                          ),
                        ),
                      );
                    },
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