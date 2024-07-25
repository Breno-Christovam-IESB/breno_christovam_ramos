import 'package:mobx/mobx.dart';
import '../models/disciplina.dart';
import '../database_helper.dart';

// Importa a biblioteca do MobX para gerar o código de gerenciamento de estado
// criando o disciplina_store.g.dart.
part 'disciplina_store.g.dart';

// Define a classe `DisciplinaStore` que usa o mixin `_$DisciplinaStore`
// para gerar o código de gerenciamento de estado com MobX.
class DisciplinaStore = _DisciplinaStore with _$DisciplinaStore;

// Define a classe abstrata `_DisciplinaStore` que é usada pelo MobX para
// criar a implementação concreta de `DisciplinaStore` com o gerenciamento de estado.
abstract class _DisciplinaStore with Store {
  // Instância do `DatabaseHelper`, que gerencia as operações com o banco de dados.
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Define uma lista observável de disciplinas. O MobX permite que você observe
  // mudanças nessa lista e atualize a interface automaticamente quando a lista muda.
  @observable
  ObservableList<Disciplina> disciplinas = ObservableList<Disciplina>();

  // Define uma ação para carregar todas as disciplinas do banco de dados
  // e atualizar a lista observável de disciplinas.
  @action
  Future<void> loadDisciplinas() async {
    // Faz uma consulta ao banco de dados para obter todas as disciplinas.
    final data = await _dbHelper.queryAllDisciplinas();
    // Atualiza a lista observável de disciplinas com os dados consultados,
    // mapeando cada item para um objeto `Disciplina`.
    disciplinas = ObservableList.of(data.map((e) => Disciplina.fromMap(e)).toList());
  }

  // Define uma ação para adicionar uma nova disciplina ao banco de dados e
  // atualizar a lista de disciplinas.
  @action
  Future<void> addDisciplina(Disciplina disciplina) async {
    // Insere a nova disciplina no banco de dados.
    await _dbHelper.insertDisciplina(disciplina);
    // Carrega novamente todas as disciplinas para atualizar a lista observável.
    loadDisciplinas();
  }

  // Define uma ação para remover uma disciplina do banco de dados e
  // atualizar a lista de disciplinas.
  @action
  Future<void> removeDisciplina(int id) async {
    // Remove a disciplina do banco de dados pelo ID.
    await _dbHelper.deleteDisciplina(id);
    // Carrega novamente todas as disciplinas para atualizar a lista observável.
    loadDisciplinas();
  }
}