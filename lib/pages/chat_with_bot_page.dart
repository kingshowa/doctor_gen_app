import 'package:flutter/material.dart';

class ChatWithBotPage extends StatelessWidget {
  const ChatWithBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat with Bot"), centerTitle: true),
      body: Center(
        child: Text(
          "This is the Chat with Bot page.",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
