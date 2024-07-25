import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast_web/sembast_web.dart';
import '../models/disciplina.dart';
import '../models/nota.dart';

// Define a classe DatabaseHelper para gerenciar o acesso ao banco de dados.
class DatabaseHelper {
  // Instância única do DatabaseHelper (singleton).
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Referência para o banco de dados SQLite (sqflite).
  sqflite.Database? _sqfliteDatabase;
  // Referência para o banco de dados Sembast.
  sembast.Database? _sembastDatabase;
  // Referência para a loja de disciplinas no banco de dados Sembast.
  sembast.StoreRef<int, Map<String, dynamic>>? _disciplinasStore;
  // Referência para a loja de notas no banco de dados Sembast.
  sembast.StoreRef<int, Map<String, dynamic>>? _notasStore;

  // Construtor privado para inicializar a instância única.
  DatabaseHelper._privateConstructor() {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Inicializa as lojas para disciplinas e notas no banco de dados Sembast.
      _disciplinasStore = sembast.intMapStoreFactory.store('disciplinas');
      _notasStore = sembast.intMapStoreFactory.store('notas');
    } else {
      // Inicializa a configuração FFI para SQLite.
      sqfliteFfiInit();
    }
  }

  // Propriedade para obter o banco de dados SQLite (se estiver disponível).
  Future<sqflite.Database> get sqfliteDatabase async {
    // Se o banco de dados já estiver inicializado, retorne-o.
    if (_sqfliteDatabase != null) return _sqfliteDatabase!;
    // Caso contrário, inicialize o banco de dados SQLite e retorne-o.
    _sqfliteDatabase = await _initSqfliteDB();
    return _sqfliteDatabase!;
  }

  // Método para inicializar o banco de dados SQLite.
  Future<sqflite.Database> _initSqfliteDB() async {
    // Obtém o caminho para o banco de dados.
    String path = await _getDatabasePath('app_database.db');
    // Abre o banco de dados SQLite e cria as tabelas se elas não existirem.
    return await sqflite.openDatabase(
      path,
      onCreate: (db, version) {
        // Cria a tabela de disciplinas.
        db.execute('''
          CREATE TABLE disciplinas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT
          )
        ''');
        // Cria a tabela de notas.
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

  // Método para obter o caminho do banco de dados.
  Future<String> _getDatabasePath(String dbName) async {
    // Obtém o caminho para os bancos de dados no dispositivo.
    var databasesPath = await sqflite.getDatabasesPath();
    // Retorna o caminho completo para o banco de dados.
    return join(databasesPath, dbName);
  }

  // Propriedade para obter o banco de dados Sembast (se estiver disponível).
  Future<sembast.Database> get sembastDatabase async {
    // Se o banco de dados já estiver inicializado, retorne-o.
    if (_sembastDatabase != null) return _sembastDatabase!;
    // Caso contrário, inicialize o banco de dados Sembast para a web e retorne-o.
    _sembastDatabase = await sembastWebInit();
    return _sembastDatabase!;
  }

  // Método para inicializar o banco de dados Sembast para a web.
  Future<sembast.Database> sembastWebInit() async {
    // Abre o banco de dados Sembast na web.
    return await databaseFactoryWeb.openDatabase('app_database.db');
  }

  // Método para consultar todas as disciplinas.
  Future<List<Map<String, dynamic>>> queryAllDisciplinas() async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e consulta a loja de disciplinas.
      final db = await sembastDatabase;
      final records = await _disciplinasStore!.find(db);
      // Retorna a lista de registros convertidos em mapas.
      return records.map((e) => e.value).toList();
    } else {
      // Obtém o banco de dados SQLite e consulta a tabela de disciplinas.
      final db = await sqfliteDatabase;
      return await db.query('disciplinas');
    }
  }

  // Método para inserir uma nova disciplina.
  Future<void> insertDisciplina(Disciplina disciplina) async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e adiciona a disciplina à loja.
      final db = await sembastDatabase;
      await _disciplinasStore!.add(db, disciplina.toMap());
    } else {
      // Obtém o banco de dados SQLite e insere a disciplina na tabela.
      final db = await sqfliteDatabase;
      await db.insert('disciplinas', disciplina.toMap());
    }
  }

  // Método para excluir uma disciplina pelo ID.
  Future<void> deleteDisciplina(int id) async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e exclui o registro da loja.
      final db = await sembastDatabase;
      await _disciplinasStore!.record(id).delete(db);
    } else {
      // Obtém o banco de dados SQLite e exclui o registro da tabela.
      final db = await sqfliteDatabase;
      await db.delete('disciplinas', where: 'id = ?', whereArgs: [id]);
    }
  }

  // Método para consultar notas por disciplina.
  Future<List<Map<String, dynamic>>> queryNotasByDisciplina(int disciplinaId) async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e consulta a loja de notas filtrando pelo ID da disciplina.
      final db = await sembastDatabase;
      final records = await _notasStore!.find(db, finder: sembast.Finder(filter: sembast.Filter.equals('disciplinaId', disciplinaId)));
      // Retorna a lista de registros convertidos em mapas.
      return records.map((e) => e.value).toList();
    } else {
      // Obtém o banco de dados SQLite e consulta a tabela de notas filtrando pelo ID da disciplina.
      final db = await sqfliteDatabase;
      return await db.query('notas', where: 'disciplinaId = ?', whereArgs: [disciplinaId]);
    }
  }

  // Método para inserir uma nova nota.
  Future<void> insertNota(Nota nota) async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e adiciona a nota à loja.
      final db = await sembastDatabase;
      await _notasStore!.add(db, nota.toMap());
    } else {
      // Obtém o banco de dados SQLite e insere a nota na tabela.
      final db = await sqfliteDatabase;
      await db.insert('notas', nota.toMap());
    }
  }

  // Método para excluir uma nota pelo ID.
  Future<void> deleteNota(int id) async {
    // Verifica se a aplicação está rodando na web.
    if (kIsWeb) {
      // Obtém o banco de dados Sembast e exclui o registro da loja.
      final db = await sembastDatabase;
      await _notasStore!.record(id).delete(db);
    } else {
      // Obtém o banco de dados SQLite e exclui o registro da tabela.
      final db = await sqfliteDatabase;
      await db.delete('notas', where: 'id = ?', whereArgs: [id]);
    }
  }
}