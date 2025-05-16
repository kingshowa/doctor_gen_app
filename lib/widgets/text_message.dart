import 'package:doctor_gen_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width * 0.75),
      child: Column(
        children: [
          //container
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 12),
            constraints: BoxConstraints(maxWidth: size.width * 0.75),
            decoration: BoxDecoration(
              color: message.backgroundColor,
              borderRadius: message.borderRadius,
            ),
            child: Text(
              message.text!,
              style: TextStyle(
                color: message.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // row for icons
          if (message.sender == MessageSender.bot)
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_outlined),
                ),
                const SizedBox(width: 10),
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_down_outlined),
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: () {
                    // Copy to clipboard
                    Clipboard.setData(ClipboardData(text: message.text!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied to clipboard")),
                    );
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
