import 'package:doctor_gen_app/data/messages.dart';
import 'package:doctor_gen_app/models/message.dart';
import 'package:doctor_gen_app/widgets/media_message.dart';
import 'package:doctor_gen_app/widgets/text_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatWithBotPage extends StatelessWidget {
  const ChatWithBotPage({super.key});

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
              // Scrollable ListVie
              Expanded(
                child: ListView.separated(
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
              // TextForm Field
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  suffixIcon: Icon(CupertinoIcons.mic),
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
