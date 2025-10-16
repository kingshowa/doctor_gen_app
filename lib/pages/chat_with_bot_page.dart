import 'dart:async';
import 'dart:io';
import 'package:doctor_gen_app/data/staticMessages.dart';
import 'package:doctor_gen_app/models/message.dart';
import 'package:doctor_gen_app/widgets/media_message.dart';
import 'package:doctor_gen_app/widgets/text_message.dart';
import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatWithBotPage extends StatefulWidget {
  const ChatWithBotPage({super.key});

  @override
  State<ChatWithBotPage> createState() => _ChatWithBotPageState();
}

class _ChatWithBotPageState extends State<ChatWithBotPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isTyping = false;
  bool _botTyping = false; // Added this
  File? _selectedImage;

  List<Message> messages = [];
  int? chat_id = null;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {
        _isTyping = _textController.text.trim().isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  /// Send text + optional image to Gemini
  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    // Add user message
    setState(() {
      messages.add(
        Message(
          text: text.isNotEmpty ? text : null,
          mediaUrl: _selectedImage?.path,
          type: _selectedImage != null ? MessageType.media : MessageType.text,
          sender: MessageSender.user,
          chatId: chat_id,
        ),
      );
      _textController.clear();
      _isTyping = false;
      _botTyping = true; // Show typing bubble
      // Save to DB
      DBHelper().addMessage(messages.last);
    });

    _scrollToBottom();

    try {
      final systemPrompt =
          "You are a helpful medical assistant. Provide accurate, concise answers (max 3 sentences). "
          "Do not give diagnoses; advise consulting a doctor when needed. Use simple, patient-friendly language.";
      final promptText = "$systemPrompt\n$text";

      String botReply = "Sorry, I couldn't process that.";

      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();

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

      // Remove typing bubble and add Gemini reply
      setState(() {
        _botTyping = false;
        messages.add(
          Message(
            text: botReply,
            type: MessageType.text,
            sender: MessageSender.bot,
          ),
        );
        _selectedImage = null;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _botTyping = false;
        messages.add(
          Message(
            text: "Error: $e",
            type: MessageType.text,
            sender: MessageSender.bot,
          ),
        );
        _selectedImage = null;
      });
      _scrollToBottom();
    }
  }

  /// Pick image and preview beside input field
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// Typing bubble widget
  Widget _buildTypingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Color(0xff2c3234),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(),
            const SizedBox(width: 4),
            _dot(),
            const SizedBox(width: 4),
            _dot(),
          ],
        ),
      ),
    );
  }

  /// Animated dot
  Widget _dot() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final id = args['id'];
    chat_id = id;

    if (id != null) {
      messages = staticMessages;
    }
    if (id == null && messages.isEmpty) {
      messages.add(
        Message(
          type: MessageType.text,
          sender: MessageSender.bot,
          text: "Hello! I am your medical assistant. How can I help you today?",
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with AI Bot"),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment:
                          message.sender == MessageSender.bot
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child:
                          message.type == MessageType.text
                              ? TextMessage(message: message)
                              : MediaMessage(message: message),
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemCount: messages.length,
                ),
              ),

              if (_botTyping)
                _buildTypingBubble(), // 👈 Shown while Gemini is generating

              const SizedBox(height: 18),
              Row(
                children: [
                  _selectedImage != null
                      ? GestureDetector(
                        onTap: () => setState(() => _selectedImage = null),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                      : IconButton(
                        icon: const Icon(Icons.photo_outlined),
                        onPressed: _pickImage,
                      ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _isTyping || _selectedImage != null
                          ? Icons.send
                          : CupertinoIcons.mic,
                    ),
                    onPressed:
                        _isTyping || _selectedImage != null
                            ? _sendMessage
                            : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
