import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/disciplina_store.dart';
import '../models/disciplina.dart';
import 'nota_page.dart';
import '../stores/nota_store.dart';

// Define a classe `DisciplinaPage` que é um widget sem estado.
class DisciplinaPage extends StatelessWidget {
  // Cria uma instância de `DisciplinaStore` para gerenciar o estado das disciplinas.
  final disciplinaStore = DisciplinaStore();

  // Cria uma instância de `NotaStore` para gerenciar o estado das notas.
  final notaStore = NotaStore(); // Criar uma instância de NotaStore

  // Controlador para o campo de texto onde o usuário digita o nome da disciplina.
  final _nomeController = TextEditingController();

  // Variável booleana para controlar se a disciplina é anual ou semestral.
  bool _isAnual = false;

  @override
  Widget build(BuildContext context) {
    // Recarrega a lista de disciplinas ao entrar na página.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      disciplinaStore.loadDisciplinas();
    });

    return Scaffold(
      // Define a barra de aplicativo com o título da página.
      appBar: AppBar(
        title: Text('Cadastro de Disciplina'),
      ),
      body: Column(
        children: [
          // Campo de entrada para o nome da disciplina, com um controlador associado.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Disciplina'),
            ),
          ),
          // Um switch para indicar se a disciplina é anual ou não.
          SwitchListTile(
            title: Text('Curso Anual'),
            value: _isAnual,
            onChanged: (value) {
              // Atualiza o valor de `_isAnual` quando o switch é alterado.
              _isAnual = value;
            },
          ),
          // Botão para adicionar uma nova disciplina.
          ElevatedButton(
            onPressed: () {
              // Cria uma nova instância de `Disciplina` com os dados fornecidos.
              final novaDisciplina = Disciplina(
                id: 0, // ID será gerado pelo banco de dados
                nome: _nomeController.text,
                isAnual: _isAnual,
              );
              // Adiciona a nova disciplina usando o `DisciplinaStore`.
              disciplinaStore.addDisciplina(novaDisciplina);
              // Retorna à tela anterior.
              Navigator.pop(context);
            },
            child: Text('Adicionar Disciplina'),
          ),
          // Exibe uma lista de disciplinas, observando as mudanças na lista.
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                // Define o número de itens na lista como o comprimento da lista de disciplinas.
                itemCount: disciplinaStore.disciplinas.length,
                itemBuilder: (context, index) {
                  // Obtém a disciplina atual com base no índice.
                  final disciplina = disciplinaStore.disciplinas[index];
                  return ListTile(
                    // Exibe o nome da disciplina como o título do item da lista.
                    title: Text(disciplina.nome),
                    // Exibe se a disciplina é anual ou semestral como subtítulo.
                    subtitle: Text(disciplina.isAnual ? 'Anual' : 'Semestral'),
                    onTap: () {
                      // Navega para a página de notas associada à disciplina selecionada.
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