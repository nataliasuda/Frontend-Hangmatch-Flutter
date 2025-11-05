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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context, {
        'name': nameController.text,
        'email': emailController.text,
      });
    }
  }

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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const AvatarSection(),
              const SizedBox(height: 40),

              InputField(
                label: "Name",
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your name";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              InputField(
                label: "Email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter your email";
                  if (!value.contains('@')) return "Enter a valid email";
                  return null;
                },
              ),
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
                validator: (value) {
                  if (passwordController.text.isNotEmpty &&
                      value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              SaveButton(onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }
}
