import 'package:doctor_gen_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
          const SizedBox(height: 20),
          Text("User Name"),
          const SizedBox(height: 10),
          Text("hhfhfhfhfff"),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              // Handle profile action
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(selectedIndex: 4),
    );
  }
}
