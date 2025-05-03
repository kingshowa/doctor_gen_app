import 'package:flutter/material.dart';

class Message {
  final MessageType type;
  final MessageSender sender;
  final String? text;
  final String? mediaUrl;

  Message({required this.type, required this.sender, this.text, this.mediaUrl});
}

extension MessageExtension on Message {
  Color get textColor {
    switch (sender) {
      case MessageSender.bot:
        return const Color(0xffffffff);
      case MessageSender.user:
        return const Color(0xff232729);
    }
  }

  Color get backgroundColor {
    switch (sender) {
      case MessageSender.user:
        return const Color(0xff7dd4fb);
      case MessageSender.bot:
        return const Color(0xff232729);
    }
  }

  BorderRadius get borderRadius {
    switch (sender) {
      case MessageSender.user:
        return const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(2),
          bottomLeft: Radius.circular(18),
        );
      case MessageSender.bot:
        return const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
          bottomLeft: Radius.circular(2),
        );
    }
  }
}

enum MessageType { text, media }

enum MessageSender { user, bot }
