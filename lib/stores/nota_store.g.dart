// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nota_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotaStore on _NotaStore, Store {
  late final _$notasAtom = Atom(name: '_NotaStore.notas', context: context);

  @override
  ObservableList<Nota> get notas {
    _$notasAtom.reportRead();
    return super.notas;
  }

  @override
  set notas(ObservableList<Nota> value) {
    _$notasAtom.reportWrite(value, super.notas, () {
      super.notas = value;
    });
  }

  late final _$loadNotasAsyncAction =
      AsyncAction('_NotaStore.loadNotas', context: context);

  @override
  Future<void> loadNotas(int disciplinaId) {
    return _$loadNotasAsyncAction.run(() => super.loadNotas(disciplinaId));
  }

  late final _$addNotaAsyncAction =
      AsyncAction('_NotaStore.addNota', context: context);

  @override
  Future<void> addNota(Nota nota) {
    return _$addNotaAsyncAction.run(() => super.addNota(nota));
  }

  late final _$removeNotaAsyncAction =
      AsyncAction('_NotaStore.removeNota', context: context);

  @override
  Future<void> removeNota(int id, int disciplinaId) {
    return _$removeNotaAsyncAction
        .run(() => super.removeNota(id, disciplinaId));
  }

  @override
  String toString() {
    return '''
notas: ${notas}
    ''';
  }
}
