import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:doctor_gen_app/models/message.dart';
import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:doctor_gen_app/services/chat_service.dart';

class SpeakToBotPage extends StatefulWidget {
  const SpeakToBotPage({super.key});

  @override
  State<SpeakToBotPage> createState() => _SpeakToBotPageState();
}

class _SpeakToBotPageState extends State<SpeakToBotPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  String _recognizedText = '';
  bool _botProcessing = false;

  int? chatId;
  List<Message> _messages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final id = args?['id'];
    chatId = id;

    if (chatId != null) {
      _messages = await DBHelper().getMessagesByChat(chatId!);
      setState(() {});
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    print("Speech recognition available: $available");
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    print("Stopped listening. Recognized text: $_recognizedText");
    if (_recognizedText.isNotEmpty) {
      await _sendVoiceMessage(_recognizedText);
      setState(() => _recognizedText = '');
    }
  }

  Future<void> _sendVoiceMessage(String text) async {
    //if (chatId == null) return;

    setState(() => _botProcessing = true);

    final userMessage = Message(
      text: text,
      sender: MessageSender.user,
      type: MessageType.text,
      chatId: chatId,
    );

    try {
      // Use ChatService to send message and get bot reply
      final botMessage = await ChatService().sendMessage(
        userMessage: userMessage,
        conversationHistory: _messages,
      );

      // Update local messages list for context
      _messages.add(userMessage);
      _messages.add(botMessage);
      chatId ??= botMessage.chatId;
      // Speak the bot reply
      await _tts.speak(botMessage.text ?? '');
    } catch (e) {
      // Optionally handle error
    } finally {
      setState(() => _botProcessing = false);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speak to Bot"),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset("assets/images/doctalk.png", height: 300),
            ),
          ),

          /// Display currently recognized speech
          if (_recognizedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                _recognizedText,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

          if (_botProcessing)
            const Center(
              child: CircularProgressIndicator(color: Color(0xff7dd4fb)),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Navigate back to full chat page
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton.filledTonal(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: {'id': chatId},
                  );
                },
                icon: const Icon(Icons.chat_outlined),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xff2c3234),
                ),
                color: Colors.white,
              ),
            ),

            /// Microphone button
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0xff2c3234), spreadRadius: 20),
                ],
              ),
              child: IconButton.filledTonal(
                onPressed: _isListening ? _stopListening : _startListening,
                icon: SvgPicture.asset(
                  'assets/icons/mingcute--mic-2-fill.svg',
                  width: 40,
                  height: 40,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xff3e4143),
                ),
              ),
            ),

            /// More actions
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xff2c3234),
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
