import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:doctor_gen_app/models/message.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  /// Sends message (text or image) to Gemini and returns bot reply
  Future<Message> sendMessage({
    required Message userMessage,
    required List<Message> conversationHistory,
    File? imageFile,
  }) async {
    final db = DBHelper();

    // Save user message first
    final chatId = await db.addMessage(userMessage);

    // Build conversation context (last 6 messages)
    const int maxHistory = 6;
    final history =
        conversationHistory.length > maxHistory
            ? conversationHistory.sublist(
              conversationHistory.length - maxHistory,
            )
            : conversationHistory;

    final buffer = StringBuffer();
    for (var msg in history) {
      final role = msg.sender == MessageSender.user ? "User" : "Bot";
      buffer.writeln("$role: ${msg.text}");
    }

    final systemPrompt =
        "You are a helpful medical assistant. Provide accurate, concise answers (max 3 sentences). "
        "Do not give diagnoses; advise consulting a doctor when needed. Use simple, patient-friendly language.";

    final promptText = """
$systemPrompt

Here is the recent conversation between you and the user:
$buffer

User: ${userMessage.text ?? ''}
Bot:
""";

    String botReply = "Sorry, I couldn't process that.";

    try {
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        final response = await Gemini.instance.textAndImage(
          text: promptText,
          images: [bytes],
        );
        botReply =
            response?.output ??
            response?.content?.parts?.last.toString() ??
            botReply;
      } else {
        final response = await Gemini.instance.prompt(
          parts: [Part.text(promptText)],
        );
        botReply =
            response?.output ??
            response?.content?.parts?.last.toString() ??
            botReply;
      }

      final botMessage = Message(
        text: botReply,
        type: MessageType.text,
        sender: MessageSender.bot,
        chatId: chatId,
      );

      await db.addMessage(botMessage);
      return botMessage;
    } catch (e) {
      final errorMessage = Message(
        text: "Sorry, something went wrong. Please try again.",
        type: MessageType.text,
        sender: MessageSender.bot,
        chatId: chatId,
      );
      await db.addMessage(errorMessage);
      return errorMessage;
    }
  }
}
