import 'package:mobx/mobx.dart';
import '../models/disciplina.dart';
import '../database_helper.dart';

part 'disciplina_store.g.dart';

class DisciplinaStore = _DisciplinaStore with _$DisciplinaStore;

abstract class _DisciplinaStore with Store {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @observable
  ObservableList<Disciplina> disciplinas = ObservableList<Disciplina>();

  @action
  Future<void> loadDisciplinas() async {
    final data = await _dbHelper.queryAllDisciplinas();
    disciplinas = ObservableList.of(data.map((e) => Disciplina.fromMap(e)).toList());
  }

  @action
  Future<void> addDisciplina(Disciplina disciplina) async {
    await _dbHelper.insertDisciplina(disciplina);
    loadDisciplinas();
  }

  @action
  Future<void> removeDisciplina(int id) async {
    await _dbHelper.deleteDisciplina(id);
    loadDisciplinas();
  }
}