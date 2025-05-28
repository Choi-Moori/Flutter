import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shopping_mall.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 유저 테이블
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            password TEXT NOT NULL,
            role TEXT NOT NULL CHECK (role IN ('super_admin', 'admin', 'guest')),
            is_approved INTEGER NOT NULL DEFAULT 0
          )
        ''');

        // 상품 테이블
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price INTEGER NOT NULL,
            category TEXT NOT NULL
          )
        ''');

        // 장바구니 테이블
        await db.execute('''
          CREATE TABLE cart (
            user_id TEXT,
            product_id INTEGER,
            quantity INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
          )
        ''');

        // 주문 테이블
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            product_id INTEGER,
            quantity INTEGER NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
          )
        ''');

        // 최고 관리자 계정 기본 삽입
        await db.insert('users', {
          'id': 'admin',
          'password': '1234',
          'role': 'super_admin',
          'is_approved': 1
        });
      },
    );
  }

  // 🔹 회원가입용 메서드
  Future<void> insertUser(String id, String password, String role) async {
    final db = await database;
    final isApproved = role == 'admin' ? 0 : 1;
    await db.insert(
      'users',
      {
        'id': id,
        'password': password,
        'role': role,
        'is_approved': isApproved
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
}


  // 🔹 로그인 인증 (관리자 승인 여부까지 확인)
  Future<Map<String, dynamic>?> validateUser(String id, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [id, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // 🔹 관리자 승인용
  Future<void> approveAdmin(String id) async {
    final db = await database;
    await db.update(
      'users',
      {'is_approved': 1},
      where: 'id = ? AND role = ?',
      whereArgs: [id, 'admin'],
    );
  }

  // 🔹 승인 대기 관리자 목록
  Future<List<Map<String, dynamic>>> getPendingAdmins() async {
    final db = await database;
    return await db.query(
      'users',
      where: 'role = ? AND is_approved = 0',
      whereArgs: ['admin'],
    );
  }
}
