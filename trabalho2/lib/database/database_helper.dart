import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/computer_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const _databaseName = "pc_build_tracker.db";
  static const _databaseVersion = 3; 
  static const _tableName = 'computers';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        processor TEXT,
        ram TEXT,
        gpu TEXT,
        powerSupply TEXT,
        caseModel TEXT,
        motherboard TEXT,
        operatingSystem TEXT,
        storageType TEXT,
        ssdCount INTEGER,
        hdCount INTEGER,
        imagePath TEXT, 
        isComplete INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE $_tableName ADD COLUMN isComplete INTEGER DEFAULT 1
      ''');
    }
  }

  Future<int> insertComputer(Computer computer) async {
    final db = await database;
    return await db.insert(
      _tableName,
      computer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateComputer(Computer computer) async {
    final db = await database;
    return await db.update(
      _tableName,
      computer.toMap(),
      where: 'id = ?',
      whereArgs: [computer.id],
    );
  }

  Future<List<Computer>> getComputers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Computer.fromMap(maps[i]);
    });
  }

  Future<int> deleteComputer(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}