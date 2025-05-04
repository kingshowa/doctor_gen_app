import 'package:doctor_gen_app/widgets/action_card.dart';
import 'package:doctor_gen_app/widgets/bottom_nav_bar.dart';
import 'package:doctor_gen_app/widgets/bunner_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> history = [
      "How to manage stress and anxiety during exams?",
      "What are the best exercises for weight loss?",
      "How to improve sleep quality?",
      "What are the benefits of meditation?",
      "How to maintain a balanced diet?",
      "What are the symptoms of dehydration?",
    ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Premium card
            BunnerCard(),
            SizedBox(height: 20),
            // Row of 2 cards
            Row(
              children: [
                ActionCard(
                  icon: Icons.edit_document,
                  text: "Generate health advice and remedy ideas now.",
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                ),
                const SizedBox(width: 16),
                ActionCard(
                  icon: Icons.tips_and_updates_outlined,
                  text: "Your daily health recommendations nd tips.",
                  onPressed: () {
                    Navigator.pushNamed(context, '/tips');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Heading Text
            Text(
              "History",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Wrap(
              runSpacing: 14,
              children: List.generate(history.length, (index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/chat");
                  },
                  titleTextStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  title: Text(
                    history[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Icon(Icons.chat_outlined),
                  trailing: Icon(Icons.arrow_forward_rounded),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}
