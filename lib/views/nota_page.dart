import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../stores/nota_store.dart';
import '../models/nota.dart';
import '../models/disciplina.dart';

// Define a classe `NotaPage` como um widget estático.
class NotaPage extends StatelessWidget {
  // Declara a variável `disciplina` que é passada para esta página.
  final Disciplina disciplina;

  // Declara a variável `notaStore` que gerencia o estado das notas.
  final NotaStore notaStore;

  // Construtor da classe, recebe uma `Disciplina` e opcionalmente um `NotaStore`.
  // Se `notaStore` não for fornecido, uma nova instância de `NotaStore` é criada.
  NotaPage({required this.disciplina, NotaStore? notaStore})
      : notaStore = notaStore ?? NotaStore(); // Usar NotaStore padrão se não fornecido

  @override
  Widget build(BuildContext context) {
    // Carrega as notas para a disciplina fornecida.
    notaStore.loadNotas(disciplina.id);

    // Cria um controlador para o campo de texto de entrada da nota.
    final _notaController = TextEditingController();
    // Define a variável `_bimestre` com o valor inicial de 1.
    int _bimestre = 1;

    // Define a estrutura visual da página.
    return Scaffold(
      // Define a barra de aplicativo no topo da página.
      appBar: AppBar(
        // Define o título da barra de aplicativo, que inclui o nome da disciplina.
        title: Text('Lançamento de Notas - ${disciplina.nome}'),
      ),
      // Define o corpo da página.
      body: Column(
        children: [
          // Adiciona um padding ao redor do campo de texto de entrada.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Define o controlador do campo de texto.
              controller: _notaController,
              // Define a decoração do campo de texto com um rótulo.
              decoration: InputDecoration(labelText: 'Nota'),
              // Define o tipo de teclado como numérico.
              keyboardType: TextInputType.number,
            ),
          ),
          // Adiciona um padding ao redor do DropdownButton para selecionar o bimestre.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              // Define o valor inicial do DropdownButton.
              value: _bimestre,
              // Define a função a ser chamada quando o valor é alterado.
              onChanged: (value) {
                // Atualiza o valor de `_bimestre` se `value` não for nulo.
                if (value != null) {
                  _bimestre = value;
                }
              },
              // Cria os itens do DropdownButton com base no número de bimestres.
              items: List.generate(disciplina.isAnual ? 4 : 2, (index) {
                // Retorna um DropdownMenuItem para cada bimestre.
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('Bimestre ${index + 1}'),
                );
              }),
            ),
          ),
          // Adiciona um botão elevado para adicionar a nota.
          ElevatedButton(
            onPressed: () {
              // Obtém o texto da nota do controlador.
              final notaText = _notaController.text;
              // Verifica se o texto não está vazio.
              if (notaText.isNotEmpty) {
                try {
                  // Cria uma nova nota com base no texto do controlador e no bimestre selecionado.
                  final novaNota = Nota(
                    id: 0, // ID será gerado pelo banco de dados.
                    disciplinaId: disciplina.id,
                    nota: double.parse(notaText), // Converte o texto para um número decimal.
                    bimestre: _bimestre,
                    descricao: 'Descrição da Nota', // Fornecendo a descrição
                    valor: double.parse(notaText), // Fornecendo o valor
                  );
                  // Adiciona a nova nota ao `notaStore`.
                  notaStore.addNota(novaNota);
                  // Volta para a tela anterior.
                  Navigator.pop(context);
                } catch (e) {
                  // Adiciona tratamento de erro para a conversão de texto e adição de nota.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar nota: $e')),
                  );
                }
              } else {
                // Exibe uma mensagem de erro se o campo de nota estiver vazio.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Por favor, insira uma nota.')),
                );
              }
            },
            // Texto exibido no botão.
            child: Text('Adicionar Nota'),
          ),
          // Expande o widget para preencher o espaço restante.
          Expanded(
            child: Observer(
              // Observa as mudanças no estado do `notaStore`.
              builder: (_) => ListView.builder(
                // Define o número de itens na lista com base na quantidade de notas.
                itemCount: notaStore.notas.length,
                // Constrói o widget para cada item da lista.
                itemBuilder: (context, index) {
                  final nota = notaStore.notas[index];
                  return ListTile(
                    // Define o texto exibido no item da lista, incluindo o bimestre e a nota.
                    title: Text('Bimestre ${nota.bimestre}: ${nota.nota}'),
                    trailing: IconButton(
                      // Adiciona um ícone de botão para excluir a nota.
                      icon: Icon(Icons.delete),
                      // Define a função a ser chamada ao pressionar o botão.
                      onPressed: () {
                        // Remove a nota com base no ID e ID da disciplina.
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