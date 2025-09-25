import 'dart:async';
import 'dart:io';
import 'package:doctor_gen_app/consts.dart';
import 'package:doctor_gen_app/data/messages.dart';
import 'package:doctor_gen_app/models/message.dart';
import 'package:doctor_gen_app/widgets/media_message.dart';
import 'package:doctor_gen_app/widgets/text_message.dart';
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

  @override
  void initState() {
    super.initState();

    // Initialize Gemini
    Gemini.init(apiKey: API_KEY, enableDebugging: true);

    _textController.addListener(() {
      setState(() {
        _isTyping = _textController.text.trim().isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        Message(text: text, type: MessageType.text, sender: MessageSender.user),
      );
      _textController.clear();
      _isTyping = false;
    });

    _scrollToBottom();

    // Call Gemini AI
    try {
      final response = await Gemini.instance.prompt(parts: [Part.text(text)]);

      final botReply = response?.output ?? "Sorry, I couldn’t process that.";

      setState(() {
        messages.add(
          Message(
            text: botReply,
            type: MessageType.text,
            sender: MessageSender.bot,
          ),
        );
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        messages.add(
          Message(
            text: "Error: $e",
            type: MessageType.text,
            sender: MessageSender.bot,
          ),
        );
      });
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        messages.add(
          Message(
            mediaUrl: imageFile.path,
            type: MessageType.media,
            sender: MessageSender.user,
          ),
        );
        print("Image path: ${imageFile.path}");
      });

      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with AI Bot"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Handle settings action
            },
          ),
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
              const SizedBox(height: 18),
              TextFormField(
                controller: _textController,
                minLines: 1,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.photo_outlined),
                    onPressed: _pickImage,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isTyping ? Icons.send : CupertinoIcons.mic),
                    onPressed: _isTyping ? _sendMessage : null,
                  ),
                  hintText: "Type your message...",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
