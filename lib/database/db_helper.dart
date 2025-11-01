import 'dart:developer';
import 'package:doctor_gen_app/models/health_data.dart';
import 'package:doctor_gen_app/models/message.dart';
import 'package:doctor_gen_app/models/preferences.dart';
import 'package:doctor_gen_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:doctor_gen_app/models/chat.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'patient_chatbot.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        created_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chat_id INTEGER,
        sender TEXT,
        type TEXT,
        message TEXT,
        media_url TEXT,
        timestamp TEXT,
        FOREIGN KEY (chat_id) REFERENCES chats(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        theme_mode TEXT,
        language TEXT,
        voice_gender TEXT,
        voice_speed REAL,
        voice_pitch REAL,
        notifications_enabled INTEGER,
        save_conversations INTEGER,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      );
      ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        password_hash TEXT,
        gender TEXT,
        date_of_birth TEXT,
        image_path TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      );
      ''');

    await db.execute('''
      CREATE TABLE health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        height_cm REAL,
        weight_kg REAL,
        blood_type TEXT,
        allergies TEXT,
        medical_conditions TEXT,
        medications TEXT,
        last_checkup_date TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      );
      ''');

    log("Tables created successfully");
  }

  // ------------------ CHAT METHODS ------------------

  Future<int> createChat(String title) async {
    final db = await database;
    final id = await db.insert('chats', {
      'title': title,
      'created_at': DateTime.now().toIso8601String(),
    });
    log("Chat created with ID: $id");
    return id;
  }

  Future<List<Chat>> getAllChats() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'chats',
      orderBy: 'created_at DESC',
    );
    // Map each record to a Chat object
    return result.map((map) => Chat.fromMap(map)).toList();
  }

  Future<void> deleteChat(int chatId) async {
    final db = await database;
    await db.delete('chats', where: 'id = ?', whereArgs: [chatId]);
  }

  // ------------------ MESSAGE METHODS ------------------

  Future<int> addMessage(Message message) async {
    final db = await database;
    int chatId;
    if (message.chatId == null) {
      // Use a default title if message.text is null
      chatId = await createChat(message.text ?? 'Untitled Chat');
    } else {
      chatId = message.chatId!;
    }
    final id = await db.insert('messages', {
      'chat_id': chatId,
      'sender': message.sender.name,
      'type': message.type.name,
      'message': message.text,
      'media_url': message.mediaUrl,
      'timestamp': DateTime.now().toIso8601String(),
    });

    log("Message added to chat ID: $chatId with Message ID: $id");
    return chatId;
  }

  Future<List<Message>> getMessagesByChat(int chatId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
      orderBy: 'id ASC',
    );

    return result.map((map) => Message.fromMap(map)).toList();
  }

  Future<void> deleteMessagesByChat(int chatId) async {
    final db = await database;
    await db.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
  }

  // ------------------ PREFERENCES METHODS ------------------

  // Insert or update preferences for a specific user
  Future<void> upsertPreferences(Preferences preferences) async {
    final db = await database;
    final existing = await db.query(
      'preferences',
      where: 'user_id = ?',
      whereArgs: [preferences.userId],
    );
    if (existing.isEmpty) {
      await db.insert('preferences', preferences.toMap());
      log("Preferences inserted for user ID: ${preferences.userId}");
    } else {
      await db.update(
        'preferences',
        preferences.toMap(),
        where: 'user_id = ?',
        whereArgs: [preferences.userId],
      );
      log("Preferences updated for user ID: ${preferences.userId}");
    }
  }

  // Retrieve preferences for a specific user
  Future<Preferences?> getPreferences(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'preferences',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return Preferences.fromMap(result.first);
    } else {
      log("No preferences found for user ID: $userId");
      return null;
    }
  }

  // ------------------ USER METHODS ------------------

  // Create a new user
  Future<int> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    log("User created with ID: $id");
    return id;
  }

  // Update existing user
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    log("User updated with ID: ${user.id}");
  }

  // Get user by ID
  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      log("No user found with ID: $userId");
      return null;
    }
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      log("No user found with email: $email");
      return null;
    }
  }

  // Delete user by ID
  Future<void> deleteUser(int userId) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
    log("User deleted with ID: $userId");
  }

  // -------------------- HEALTH DATA METHODS ------------------
  Future<void> upsertHealthData(HealthData healthData) async {
    final db = await database;
    final existing = await db.query(
      'health_data',
      where: 'user_id = ?',
      whereArgs: [healthData.userId],
    );
    if (existing.isEmpty) {
      await db.insert('health_data', healthData.toMap());
      log("Health data inserted for user ID: ${healthData.userId}");
    } else {
      await db.update(
        'health_data',
        healthData.toMap(),
        where: 'user_id = ?',
        whereArgs: [healthData.userId],
      );
      log("Health data updated for user ID: ${healthData.userId}");
    }
  }

  // Retrieve health data for a specific user
  Future<HealthData?> getHealthData(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'health_data',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return HealthData.fromMap(result.first);
    } else {
      log("No health data found for user ID: $userId");
      return null;
    }
  }

  // Delete health data for a specific user
  Future<void> deleteHealthData(int userId) async {
    final db = await database;
    await db.delete('health_data', where: 'user_id = ?', whereArgs: [userId]);
    log("Health data deleted for user ID: $userId");
  }

  // ------------------ UTILS ------------------

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('messages');
    await db.delete('chats');
    log("All chats and messages cleared");
  }
}
