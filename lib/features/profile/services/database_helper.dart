import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pet_owner.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pet_owners.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pet_owners(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        imagePath TEXT,
        bio TEXT,
        interests TEXT,
        rating REAL,
        gender TEXT,
        dateOfBirth TEXT,
        createdAt TEXT NOT NULL,
        preferredContactMethod TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE friends(
        owner_email TEXT NOT NULL,
        friend_email TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(owner_email) REFERENCES pet_owners(email),
        FOREIGN KEY(friend_email) REFERENCES pet_owners(email),
        PRIMARY KEY(owner_email, friend_email)
      )
    ''');

    await db.execute('''
      CREATE TABLE service_bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        owner_email TEXT NOT NULL,
        service_type TEXT NOT NULL,
        service_name TEXT NOT NULL,
        booking_date TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY(owner_email) REFERENCES pet_owners(email)
      )
    ''');

    await db.execute('''
      CREATE TABLE settings(
        owner_email TEXT PRIMARY KEY,
        dark_mode INTEGER NOT NULL DEFAULT 0,
        notifications_enabled INTEGER NOT NULL DEFAULT 1,
        language TEXT NOT NULL DEFAULT 'English',
        FOREIGN KEY(owner_email) REFERENCES pet_owners(email)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create new tables for version 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS friends(
          owner_email TEXT NOT NULL,
          friend_email TEXT NOT NULL,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL,
          FOREIGN KEY(owner_email) REFERENCES pet_owners(email),
          FOREIGN KEY(friend_email) REFERENCES pet_owners(email),
          PRIMARY KEY(owner_email, friend_email)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS service_bookings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          owner_email TEXT NOT NULL,
          service_type TEXT NOT NULL,
          service_name TEXT NOT NULL,
          booking_date TEXT NOT NULL,
          status TEXT NOT NULL,
          notes TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY(owner_email) REFERENCES pet_owners(email)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings(
          owner_email TEXT PRIMARY KEY,
          dark_mode INTEGER NOT NULL DEFAULT 0,
          notifications_enabled INTEGER NOT NULL DEFAULT 1,
          language TEXT NOT NULL DEFAULT 'English',
          FOREIGN KEY(owner_email) REFERENCES pet_owners(email)
        )
      ''');

      // Add new columns to pet_owners table
      await db.execute('ALTER TABLE pet_owners ADD COLUMN preferredContactMethod TEXT');
      await db.execute('ALTER TABLE pet_owners ADD COLUMN lastUpdated TEXT');
    }
  }

  Future<int> insertPetOwner(PetOwner owner) async {
    final db = await database;
    return await db.insert(
      'pet_owners',
      {
        'name': owner.name,
        'email': owner.email,
        'phone': owner.phone,
        'address': owner.address,
        'imagePath': owner.imagePath,
        'bio': owner.bio,
        'interests': owner.interests?.join(','),
        'rating': owner.rating,
        'gender': owner.gender,
        'dateOfBirth': owner.dateOfBirth?.toIso8601String(),
        'createdAt': owner.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> savePetOwner(PetOwner owner) async {
    final db = await database;
    await db.insert(
      'pet_owners',
      owner.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePetOwner(PetOwner owner) async {
    final db = await database;
    await db.update(
      'pet_owners',
      owner.toMap(),
      where: 'email = ?',
      whereArgs: [owner.email],
    );
  }

  Future<List<PetOwner>> getPetOwners() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pet_owners');
    
    return List.generate(maps.length, (i) {
      return PetOwner(
        name: maps[i]['name'] as String,
        email: maps[i]['email'] as String,
        phone: maps[i]['phone'] as String,
        address: maps[i]['address'] as String,
        imagePath: maps[i]['imagePath'] as String?,
        bio: maps[i]['bio'] as String?,
        interests: maps[i]['interests']?.split(','),
        rating: maps[i]['rating'] as double?,
        gender: maps[i]['gender'] as String?,
        dateOfBirth: maps[i]['dateOfBirth'] != null 
            ? DateTime.parse(maps[i]['dateOfBirth'] as String)
            : null,
        createdAt: DateTime.parse(maps[i]['createdAt'] as String),
      );
    });
  }

  Future<int> updatePetOwnerOld(PetOwner owner) async {
    final db = await database;
    return await db.update(
      'pet_owners',
      {
        'name': owner.name,
        'email': owner.email,
        'phone': owner.phone,
        'address': owner.address,
        'imagePath': owner.imagePath,
        'bio': owner.bio,
        'interests': owner.interests?.join(','),
        'rating': owner.rating,
        'gender': owner.gender,
        'dateOfBirth': owner.dateOfBirth?.toIso8601String(),
        'createdAt': owner.createdAt.toIso8601String(),
      },
      where: 'email = ?',
      whereArgs: [owner.email],
    );
  }

  Future<int> deletePetOwner(String email) async {
    final db = await database;
    return await db.delete(
      'pet_owners',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
