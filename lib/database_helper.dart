import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast_web/sembast_web.dart';
import '../models/disciplina.dart';
import '../models/nota.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  sqflite.Database? _sqfliteDatabase;
  sembast.Database? _sembastDatabase;
  sembast.StoreRef<int, Map<String, dynamic>>? _disciplinasStore;
  sembast.StoreRef<int, Map<String, dynamic>>? _notasStore;

  DatabaseHelper._privateConstructor() {
    if (kIsWeb) {
      _disciplinasStore = sembast.intMapStoreFactory.store('disciplinas');
      _notasStore = sembast.intMapStoreFactory.store('notas');
    } else {
      sqfliteFfiInit();
    }
  }

  Future<sqflite.Database> get sqfliteDatabase async {
    if (_sqfliteDatabase != null) return _sqfliteDatabase!;
    _sqfliteDatabase = await _initSqfliteDB();
    return _sqfliteDatabase!;
  }

  Future<sqflite.Database> _initSqfliteDB() async {
    String path = await _getDatabasePath('app_database.db');
    return await sqflite.openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE disciplinas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE notas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            disciplinaId INTEGER,
            descricao TEXT,
            valor REAL,
            FOREIGN KEY(disciplinaId) REFERENCES disciplinas(id)
          )
        ''');
      },
      version: 1,
    );
  }

  Future<String> _getDatabasePath(String dbName) async {
    var databasesPath = await sqflite.getDatabasesPath();
    return join(databasesPath, dbName);
  }

  Future<sembast.Database> get sembastDatabase async {
    if (_sembastDatabase != null) return _sembastDatabase!;
    _sembastDatabase = await sembastWebInit();
    return _sembastDatabase!;
  }

  Future<sembast.Database> sembastWebInit() async {
    return await databaseFactoryWeb.openDatabase('app_database.db');
  }

  Future<List<Map<String, dynamic>>> queryAllDisciplinas() async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      final records = await _disciplinasStore!.find(db);
      return records.map((e) => e.value).toList();
    } else {
      final db = await sqfliteDatabase;
      return await db.query('disciplinas');
    }
  }

  Future<void> insertDisciplina(Disciplina disciplina) async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      await _disciplinasStore!.add(db, disciplina.toMap());
    } else {
      final db = await sqfliteDatabase;
      await db.insert('disciplinas', disciplina.toMap());
    }
  }

  Future<void> deleteDisciplina(int id) async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      await _disciplinasStore!.record(id).delete(db);
    } else {
      final db = await sqfliteDatabase;
      await db.delete('disciplinas', where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<List<Map<String, dynamic>>> queryNotasByDisciplina(int disciplinaId) async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      final records = await _notasStore!.find(db, finder: sembast.Finder(filter: sembast.Filter.equals('disciplinaId', disciplinaId)));
      return records.map((e) => e.value).toList();
    } else {
      final db = await sqfliteDatabase;
      return await db.query('notas', where: 'disciplinaId = ?', whereArgs: [disciplinaId]);
    }
  }

  Future<void> insertNota(Nota nota) async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      await _notasStore!.add(db, nota.toMap());
    } else {
      final db = await sqfliteDatabase;
      await db.insert('notas', nota.toMap());
    }
  }

  Future<void> deleteNota(int id) async {
    if (kIsWeb) {
      final db = await sembastDatabase;
      await _notasStore!.record(id).delete(db);
    } else {
      final db = await sqfliteDatabase;
      await db.delete('notas', where: 'id = ?', whereArgs: [id]);
    }
  }
}