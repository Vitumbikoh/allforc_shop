import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gas_fill.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure, // Optional: configure database settings
    );
  }

  Future _createDB(Database db, int version) async {
    const shopCylinderTable = '''
    CREATE TABLE shop_cylinders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cylinder_name TEXT NOT NULL,
      tare_mass REAL NOT NULL,
      gas_amount REAL NOT NULL,
      total_mass REAL NOT NULL,
      opening_mass REAL NOT NULL,
      created_at TEXT NOT NULL,
      is_paused INTEGER DEFAULT 0, -- New column for pausing state
      paused_at_mass REAL DEFAULT 0.0 -- New column for paused mass
    )
    ''';

    const customerCylinderTable = '''
    CREATE TABLE customer_cylinders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      shop_cylinder_id INTEGER NOT NULL,
      tare_mass REAL NOT NULL,
      gas_amount REAL NOT NULL,
      total_mass REAL NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (shop_cylinder_id) REFERENCES shop_cylinders (id) ON DELETE CASCADE
    )
    ''';

    await db.execute(shopCylinderTable);
    await db.execute(customerCylinderTable);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON'); // Ensure foreign key support
  }

  Future close() async {
    final db = await instance.database;
    if (db.isOpen) {
      await db.close();
    }
  }
}
