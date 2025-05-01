import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui'; // for ImageFilter

class SpeakToBotPage extends StatelessWidget {
  const SpeakToBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speak to Bot"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ), // adjust blur intensity
              child: Image.asset("assets/images/doctalk.png", height: 300),
            ),
          ),
          Text.rich(
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            TextSpan(
              text: "What kind of food is good for boosting energy ",
              children: [
                TextSpan(
                  text: "during the day to improve focus?",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          // Add more widgets as needed
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.chat_outlined),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Color(0xff2c3234),
                ),
                color: Colors.white, // optional: tint the icon
              ),
            ),

            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xff2c3234), spreadRadius: 20),
                ],
              ),
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/mingcute--mic-2-fill.svg',
                  width: 40,
                  height: 40,
                  color: Colors.white, // optional: tint the icon
                ),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Color(0xff3e4143),
                ),
              ),
            ),
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Color(0xff2c3234),
                ),
                color: Colors.white, // optional: tint the icon
              ),
            ),
          ],
        ),
      ),
    );
  }
}
