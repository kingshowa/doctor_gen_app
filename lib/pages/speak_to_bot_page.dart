import 'dart:async';
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

class _SpeakToBotPageState extends State<SpeakToBotPage>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isListening = false;
  String _recognizedText = '';
  String _botReply = '';
  bool _botProcessing = false;

  int? chatId;
  List<Message> _messages = [];

  AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

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

    if (_recognizedText.isNotEmpty) {
      await _sendVoiceMessage(_recognizedText);
      setState(() => _recognizedText = '');
    }
  }

  Future<void> _sendVoiceMessage(String text) async {
    setState(() {
      _botProcessing = true;
      _botReply = '';
    });

    final userMessage = Message(
      text: text,
      sender: MessageSender.user,
      type: MessageType.text,
      chatId: chatId,
    );

    try {
      final botMessage = await ChatService().sendMessage(
        userMessage: userMessage,
        conversationHistory: _messages,
      );

      _messages.add(userMessage);
      _messages.add(botMessage);
      chatId ??= botMessage.chatId;

      setState(() {
        _botReply = botMessage.text ?? '';
      });

      await _tts.setLanguage("en-US");
      await _tts.setVoice({
        "name": "en-us-x-sfg#male_1-local",
        "locale": "en-US",
      });
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.2);
      await _tts.setVolume(1.0);

      await _tts.speak(botMessage.text ?? '');
    } catch (e) {
      debugPrint("Error sending voice message: $e");
    } finally {
      setState(() => _botProcessing = false);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pulseValue = _pulseController?.value ?? 0.0;
    final pulseScale = 1 + (pulseValue * 0.05); // subtle scale

    return Scaffold(
      appBar: AppBar(
        title: const Text("Talk to DoctorGen"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                if (chatId != null) {
                  // Delete all messages in this chat
                  await DBHelper().deleteChat(chatId!);
                  // Optionally navigate back or show a confirmation
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat deleted successfully'),
                      ),
                    );
                    // go back to home page
                    Navigator.pushNamed(context, "/home");
                  }
                }
              } else if (value == 'share') {
                // implement share functionality
              }
              // Add more options as needed
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Chat'),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Text('Share Chat'),
                  ),
                  // Add more menu items here
                ],
            icon: const Icon(Icons.more_horiz),
          ),
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

          // Display recognized speech
          if (_recognizedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                _recognizedText,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),

          // Display bot reply while speaking
          if (_botReply.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _botReply,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Color(0xff7dd4fb),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // if (_botProcessing)
          //   const Padding(
          //     padding: EdgeInsets.only(top: 20),
          //     child: Center(
          //       child: CircularProgressIndicator(color: Color(0xff7dd4fb)),
          //     ),
          //   ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Chat page button
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

            // Mic button (original design preserved)
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0xff2c3234), spreadRadius: 20),
                ],
              ),
              child: GestureDetector(
                onLongPressStart: (_) => _startListening(),
                onLongPressEnd: (_) => _stopListening(),
                child: AnimatedBuilder(
                  animation: _pulseController!,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? pulseScale : 1.0,
                      child: IconButton.filledTonal(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/mingcute--mic-2-fill.svg',
                          width: 40,
                          height: 40,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor:
                              _isListening
                                  ? Colors.redAccent
                                  : const Color(0xff3e4143),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // More button
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
