import 'package:flutter/material.dart';
import 'package:hangmatch/screens/edit_profile.dart';
import 'package:hangmatch/screens/settings.dart';
import 'package:hangmatch/widgets/profile/profile_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Natalia';
  String _email = 'natalia@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white12,
                child: const Icon(Icons.person, color: Colors.white, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _email,
              style: const TextStyle(color: Colors.purpleAccent, fontSize: 14),
            ),
            const SizedBox(height: 40),

            ProfileButton(
              icon: Icons.edit,
              label: 'Edit profile',
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );

                if (result != null && mounted) {
                  setState(() {
                    _name = result['name'] ?? _name;
                    _email = result['email'] ?? _email;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            ProfileButton(
              icon: Icons.settings,
              label: 'Settings',
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            ProfileButton(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.white,
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
