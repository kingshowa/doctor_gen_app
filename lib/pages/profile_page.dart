import 'package:doctor_gen_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kingstone Showa",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("@healthykingshowa"),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile');
                    },
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text("Favorites"),
            onTap: () {
              // Handle profile action
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            onTap: () {
              // Handle settings action
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text("Health Data"),
            onTap: () {
              // Handle notifications action
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/ri--dislike-line.svg',
              width: 26,
              height: 26,
              color: Colors.white, // optional: tint the icon
            ),
            title: Text("Alergies"),
            onTap: () {
              // Handle settings action
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.delete_outlined),
            title: Text("Clear History"),
            onTap: () {
              // Handle settings action
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // Handle settings action
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(selectedIndex: 4),
    );
  }
}
