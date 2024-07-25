// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disciplina_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DisciplinaStore on _DisciplinaStore, Store {
  late final _$disciplinasAtom =
      Atom(name: '_DisciplinaStore.disciplinas', context: context);

  @override
  ObservableList<Disciplina> get disciplinas {
    _$disciplinasAtom.reportRead();
    return super.disciplinas;
  }

  @override
  set disciplinas(ObservableList<Disciplina> value) {
    _$disciplinasAtom.reportWrite(value, super.disciplinas, () {
      super.disciplinas = value;
    });
  }

  late final _$loadDisciplinasAsyncAction =
      AsyncAction('_DisciplinaStore.loadDisciplinas', context: context);

  @override
  Future<void> loadDisciplinas() {
    return _$loadDisciplinasAsyncAction.run(() => super.loadDisciplinas());
  }

  late final _$addDisciplinaAsyncAction =
      AsyncAction('_DisciplinaStore.addDisciplina', context: context);

  @override
  Future<void> addDisciplina(Disciplina disciplina) {
    return _$addDisciplinaAsyncAction
        .run(() => super.addDisciplina(disciplina));
  }

  late final _$removeDisciplinaAsyncAction =
      AsyncAction('_DisciplinaStore.removeDisciplina', context: context);

  @override
  Future<void> removeDisciplina(int id) {
    return _$removeDisciplinaAsyncAction.run(() => super.removeDisciplina(id));
  }

  @override
  String toString() {
    return '''
disciplinas: ${disciplinas}
    ''';
  }
}
