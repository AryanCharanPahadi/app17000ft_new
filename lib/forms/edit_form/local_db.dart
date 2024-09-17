import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'tour_school_form_data.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE school_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tourId TEXT,
        schoolName TEXT,
        formData TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE form_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tourId TEXT,
        schoolName TEXT,
        formType TEXT,
        formData TEXT
      )
    ''');
  }

  Future<void> insertSchoolData(String tourId, String schoolName, String formData) async {
    final db = await database;
    await db.insert(
      'school_data',
      {'tourId': tourId, 'schoolName': schoolName, 'formData': formData},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFormData(String tourId, String schoolName, String formType, String formData) async {
    final db = await database;
    await db.insert(
      'form_data',
      {'tourId': tourId, 'schoolName': schoolName, 'formType': formType, 'formData': formData},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchSchoolData(String tourId) async {
    final db = await database;
    return await db.query('school_data', where: 'tourId = ?', whereArgs: [tourId]);
  }

  Future<List<Map<String, dynamic>>> fetchFormData(String tourId, String schoolName, String formType) async {
    final db = await database;
    return await db.query(
      'form_data',
      where: 'tourId = ? AND schoolName = ? AND formType = ?',
      whereArgs: [tourId, schoolName, formType],
    );
  }
}
