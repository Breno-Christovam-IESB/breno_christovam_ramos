import 'package:mobx/mobx.dart';
import '../models/nota.dart';
import '../database_helper.dart';

part 'nota_store.g.dart';

class NotaStore = _NotaStore with _$NotaStore;

abstract class _NotaStore with Store {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @observable
  ObservableList<Nota> notas = ObservableList<Nota>();

  @action
  Future<void> loadNotas(int disciplinaId) async {
    final data = await _dbHelper.queryNotasByDisciplina(disciplinaId);
    notas = ObservableList.of(data.map((e) => Nota.fromMap(e)).toList());
  }

  @action
  Future<void> addNota(Nota nota) async {
    await _dbHelper.insertNota(nota);
    await loadNotas(nota.disciplinaId); // Adicionado await para garantir que as notas sejam recarregadas
  }

  @action
  Future<void> removeNota(int id, int disciplinaId) async {
    await _dbHelper.deleteNota(id);
    await loadNotas(disciplinaId); // Adicione await para garantir que as notas sejam recarregadas
  }
}