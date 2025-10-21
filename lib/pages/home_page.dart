import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:doctor_gen_app/widgets/action_card.dart';
import 'package:doctor_gen_app/widgets/bottom_nav_bar.dart';
import 'package:doctor_gen_app/widgets/bunner_card.dart';
import 'package:flutter/material.dart';
import 'package:doctor_gen_app/models/chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Chat>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    _chatsFuture = DBHelper().getAllChats();
  }

  Future<void> _refreshChats() async {
    setState(() {
      _loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Chat>>(
          future: _chatsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final chats = snapshot.data ?? [];
              return RefreshIndicator(
                onRefresh: _refreshChats,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Premium card
                    const BunnerCard(),
                    const SizedBox(height: 20),

                    // Row of 2 cards
                    Row(
                      children: [
                        ActionCard(
                          icon: Icons.edit_document,
                          text: "Generate health advice and remedy ideas now.",
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: {"id": null},
                            );
                            _refreshChats();
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
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    if (chats.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "No chats yet. Start a new conversation!",
                          ),
                        ),
                      )
                    else
                      Wrap(
                        runSpacing: 14,
                        children: List.generate(chats.length, (index) {
                          return ListTile(
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                "/chat",
                                arguments: {"id": chats[index].id},
                              );
                              _refreshChats();
                            },
                            titleTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            title: Text(
                              chats[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.chat_outlined),
                            trailing: const Icon(Icons.arrow_forward_rounded),
                          );
                        }),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}
