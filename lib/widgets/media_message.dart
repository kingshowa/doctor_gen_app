import 'dart:io';

import 'package:doctor_gen_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MediaMessage extends StatelessWidget {
  const MediaMessage({super.key, required this.message});

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
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: message.backgroundColor,
              borderRadius: message.borderRadius,
            ),
            child: Column(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      message.sender == MessageSender.bot
                          ? Image.network(
                            message.mediaUrl!,
                            height: 350,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          )
                          : // For user messages, use FileImage
                          message.mediaUrl == null
                          ? const SizedBox()
                          : // Check if the file exists before displaying it
                          message.mediaUrl!.isEmpty
                          ? const SizedBox()
                          : // Display the image from the file path
                          // Use FileImage to load the image from the file path
                          // Ensure you have the necessary permissions to access the file
                          Image.file(
                            File(message.mediaUrl!),
                            height: 350,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                ),

                // Caption
                if (message.text != "" && message.text != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      message.text!,
                      style: TextStyle(
                        color: message.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                //Icons
              ],
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
