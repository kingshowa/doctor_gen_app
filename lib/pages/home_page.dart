import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:doctor_gen_app/widgets/action_card.dart';
import 'package:doctor_gen_app/widgets/bottom_nav_bar.dart';
import 'package:doctor_gen_app/widgets/bunner_card.dart';
import 'package:flutter/material.dart';
import 'package:doctor_gen_app/models/chat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Chat>>(
          future: DBHelper().getAllChats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final chats = snapshot.data ?? [];
              return ListView(
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
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: {"id": null},
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      ActionCard(
                        icon: Icons.tips_and_updates_outlined,
                        text: "Your daily health recommendations and tips.",
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 14,
                    children: List.generate(chats.length, (index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/chat",
                            arguments: {"id": chats[index].id},
                          );
                        },
                        titleTextStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        title: Text(
                          chats[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Icon(Icons.chat_outlined),
                        trailing: Icon(Icons.arrow_forward_rounded),
                      );
                    }),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}
