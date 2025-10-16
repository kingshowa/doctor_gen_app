import 'dart:developer';
import 'package:doctor_gen_app/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<List<Map<String, dynamic>>> getAllChats() async {
    final db = await database;
    return await db.query('chats', orderBy: 'created_at DESC');
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
      'type': message.type.name, // FIXED
      'message': message.text,
      'media_url': message.mediaUrl,
      'timestamp': DateTime.now().toIso8601String(),
    });

    log("Message added to chat ID: $chatId with Message ID: $id");
    return id;
  }

  Future<List<Map<String, dynamic>>> getMessagesByChat(int chatId) async {
    final db = await database;
    return await db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );
  }

  Future<void> deleteMessagesByChat(int chatId) async {
    final db = await database;
    await db.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
  }

  // ------------------ UTILS ------------------

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('messages');
    await db.delete('chats');
    log("All chats and messages cleared");
  }
}
