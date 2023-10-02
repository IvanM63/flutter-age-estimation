import 'dart:io';

import 'package:age_recog_pkl/models/plasa.model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/visitor.model.dart';

class DBHelper {
  static Database? _db;
  static final _databaseName = "MyDatabase.db";
  static final int _databaseVersion = 1;
  static final String _tablePlasas = "plasas";
  static final String _tableVisitors = "visitors";

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    // lazily instantiate the db the first time it is accessed
    _db = await _initDatabase();
    return _db!;
  }

  // this opens the database and creates it if it doesn't exist
  _initDatabase() async {
    print("init Database");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
// SQL code to create User table
    await db.execute('''  
    CREATE TABLE $_tablePlasas(id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name STRING, 
    jalan TEXT, 
    kecamatan STRING, 
    kota STRING, 
    pengunjung STRING, 
    image STRING
     )''');
// SQL code to create Blog table
    await db.execute('''  
    CREATE TABLE $_tableVisitors(id INTEGER PRIMARY KEY AUTOINCREMENT, 
    plasa_id INTEGER, 
    acc STRING, 
    date STRING, 
    time STRING, 
    ageRange STRING, 
    gender STRING, 
    FOREIGN KEY (plasa_id) REFERENCES plasa (id)
     )''');
    print("Created TWO TABLE");
  }

  // static Future<void> initDb() async {
  //   if (_db != null) {
  //     return;
  //   }
  //   try {
  //     String _path = await getDatabasesPath() + "plasas.db";
  //     _db =
  //         await openDatabase(_path, version: _version, onCreate: (db, version) {
  //       //print("Create new table");
  //       return db.execute(
  //           "CREATE TABLE $_tablePlasas(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, jalan TEXT, kecamatan STRING, kota STRING, pengunjung STRING, image STRING)");
  //     });
  //     //create table for visitors
  //     await _db!.execute(
  //         "CREATE TABLE $_tableVisitors(id INTEGER PRIMARY KEY AUTOINCREMENT, plasa_id INTEGER NOT NULL, acc STRING, date STRING, time STRING, ageRange STRING, gender STRING, FOREIGN KEY (plasa_id) REFERENCES plasa (id))");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static Future<int> insertPlasa(Plasa? plasa) async {
    //print("insert function terrpanggil");
    return await _db!.insert(_tablePlasas, plasa!.toJson());
  }

  //update plasa
  static Future<int> updatePlasa(Plasa? plasa) async {
    //print("insert function terrpanggil");
    return await _db!.update(_tablePlasas, plasa!.toJson(),
        where: "id=?", whereArgs: [plasa.id]);
  }

  static Future<int> insertVisitor(Visitor? visitor) async {
    //print("insert function terrpanggil");
    return await _db!.insert(_tableVisitors, visitor!.toJson());
  }

  static Future<List<Map<String, dynamic>>> queryPlasa() async {
    return await _db!.query(_tablePlasas);
  }

  static Future<List<Map<String, dynamic>>> queryVisitor() async {
    return await _db!.query(_tableVisitors);
  }

  static delete(Plasa plasa) async {
    await _db!.delete(_tablePlasas, where: "id=?", whereArgs: [plasa.id]);
  }

  static update(int id) async {
    await _db!
        .rawUpdate("UPDATE $_tablePlasas SET isCompleted = 1 WHERE id = $id");
  }

  static queryVisitorByPlasaId(int id) {
    return _db!.query(_tableVisitors, where: "plasa_id=?", whereArgs: [id]);
  }
}
