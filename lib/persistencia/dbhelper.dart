import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_flutter_crud/JsonModels/llibre_model.dart';
import 'package:sqlite_flutter_crud/settings/constants_db.dart';

class DatabaseHelper {
  final databaseName = '${ConstantsDb.DATABASE_NAME}.db';
  String Table =
      'CREATE TABLE ${ConstantsDb.TABLE_LLIBRES} (${ConstantsDb.FIELD_LLIBRES_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ${ConstantsDb.FIELD_LLIBRES_TITOL} TEXT NOT NULL, ${ConstantsDb.FIELD_LLIBRES_SINOPSI} TEXT NOT NULL, ${ConstantsDb.FIELD_LLIBRES_CREATED_AT} TEXT DEFAULT CURRENT_TIMESTAMP)';


  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(Table);
    });
  }

  //Search Method
  Future<List<LlibreModel>> searchLlibres(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery('select * from ${ConstantsDb.TABLE_LLIBRES} where ${ConstantsDb.FIELD_LLIBRES_TITOL} LIKE ?', ['%$keyword%']);
    return searchResult.map((e) => LlibreModel.fromMap(e)).toList();
  }

  //CRUD Methods

  //Create Note
  Future<int> createLlibre(LlibreModel note) async {
    final Database db = await initDB();
    return db.insert(ConstantsDb.TABLE_LLIBRES, note.toMap());
  }

  //Get notes
  Future<List<LlibreModel>> getLlibres() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query(ConstantsDb.TABLE_LLIBRES);
    return result.map((e) => LlibreModel.fromMap(e)).toList();
  }

  //Delete Notes
  Future<int> deleteLlibre(int id) async {
    final Database db = await initDB();
    return db.delete(ConstantsDb.TABLE_LLIBRES, where: '${ConstantsDb.FIELD_LLIBRES_ID} = ?', whereArgs: [id]);
  }

  //Update Notes
  Future<int> updateLlibre(title, content, Id) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update ${ConstantsDb.TABLE_LLIBRES} set ${ConstantsDb.FIELD_LLIBRES_TITOL} = ?, ${ConstantsDb.FIELD_LLIBRES_SINOPSI} = ? where ${ConstantsDb.FIELD_LLIBRES_ID} = ?',
        [title, content, Id]);
  }
}
