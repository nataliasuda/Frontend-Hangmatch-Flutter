import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/profile/avatar_section.dart';
import 'package:hangmatch/widgets/profile/input_field.dart';
import 'package:hangmatch/widgets/profile/save_button.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: 'Natalia',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'natalia@example.com',
  );
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const AvatarSection(),
            const SizedBox(height: 40),
            InputField(label: "Name", controller: nameController),
            const SizedBox(height: 20),
            InputField(label: "Email", controller: emailController),
            const SizedBox(height: 20),
            InputField(
              label: "New Password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            InputField(
              label: "Confirm Password",
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 40),
            SaveButton(onPressed: (){}),
          ],
        ),
      ),
    );
  }
}