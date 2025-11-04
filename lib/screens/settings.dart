import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool lightModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              trailing: Switch(
                value: notificationsEnabled,
                activeColor: Colors.purpleAccent,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.light_mode,
              title: 'Light mode',
              trailing: Switch(
                value: lightModeEnabled,
                activeColor: Colors.purpleAccent,
                onChanged: (value) {
                  setState(() => lightModeEnabled = value);
                },
              ),
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.help_outline,
              title: 'Help & FAQ',
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.delete_forever,
              title: 'Delete account',
              color: Colors.redAccent,
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
