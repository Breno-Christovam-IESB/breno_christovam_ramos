import 'package:mobx/mobx.dart';
import '../models/nota.dart';
import '../database_helper.dart';

// Importa o arquivo gerado pelo MobX para a implementação do gerenciamento de estado
// criando a nota_store.g.dart.
part 'nota_store.g.dart';

// Define a classe `NotaStore` que usa o mixin `_$NotaStore`
// para gerar o código de gerenciamento de estado com MobX.
class NotaStore = _NotaStore with _$NotaStore;

// Define a classe abstrata `_NotaStore` que o MobX usa para criar
// a implementação concreta de `NotaStore` com o gerenciamento de estado.
abstract class _NotaStore with Store {
  // Instância do `DatabaseHelper`, que gerencia as operações com o banco de dados.
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Define uma lista observável de notas. O MobX permite que você observe
  // mudanças nesta lista e atualize a interface automaticamente quando a lista muda.
  @observable
  ObservableList<Nota> notas = ObservableList<Nota>();

  // Define uma ação para carregar todas as notas associadas a uma disciplina
  // e atualizar a lista observável de notas.
  @action
  Future<void> loadNotas(int disciplinaId) async {
    // Faz uma consulta ao banco de dados para obter todas as notas associadas à disciplina.
    final data = await _dbHelper.queryNotasByDisciplina(disciplinaId);
    // Atualiza a lista observável de notas com os dados consultados,
    // mapeando cada item para um objeto `Nota`.
    notas = ObservableList.of(data.map((e) => Nota.fromMap(e)).toList());
  }

  // Define uma ação para adicionar uma nova nota ao banco de dados e
  // atualizar a lista de notas.
  @action
  Future<void> addNota(Nota nota) async {
    // Insere a nova nota no banco de dados.
    await _dbHelper.insertNota(nota);
    // Carrega novamente todas as notas associadas à disciplina da nova nota
    // para atualizar a lista observável.
    await loadNotas(nota.disciplinaId); // Adicionado await para garantir que as notas sejam recarregadas
  }

  // Define uma ação para remover uma nota do banco de dados e
  // atualizar a lista de notas.
  @action
  Future<void> removeNota(int id, int disciplinaId) async {
    // Remove a nota do banco de dados pelo ID.
    await _dbHelper.deleteNota(id);
    // Carrega novamente todas as notas associadas à disciplina da nota removida
    // para atualizar a lista observável.
    await loadNotas(disciplinaId); // Adicionado await para garantir que as notas sejam recarregadas
  }
}