import 'package:flutter/material.dart';
import 'package:hangmatch/models/user.dart';
import 'package:hangmatch/widgets/profile/avatar_section.dart';
import 'package:hangmatch/widgets/profile/input_field.dart';
import 'package:hangmatch/widgets/profile/save_button.dart';
import 'package:hangmatch/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserService().getProfile();

      if (userData != null && mounted) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          _avatarUrl = userData['avatar_url'];
          _isInitializing = false;
        });
      } else {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  void _onAvatarChanged(String? newAvatarUrl) {
    setState(() {
      _avatarUrl = newAvatarUrl;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final isChangingPassword = passwordController.text.isNotEmpty;

    setState(() => _isLoading = true);

    try {
      final userUpdate = UserUpdate(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: isChangingPassword ? passwordController.text.trim() : null,
        repeatedPassword:
            isChangingPassword ? confirmPasswordController.text.trim() : null,
        avatarUrl: _avatarUrl,
      );

      await UserService().updateProfile(context, userUpdate);

      if (mounted) {
        Navigator.pop(context, {
          'name': nameController.text,
          'email': emailController.text,
          'avatar_url': _avatarUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

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
              AvatarSection(
                currentAvatarUrl: _avatarUrl,
                onAvatarChanged: _onAvatarChanged,
              ),
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
                  if (passwordController.text.isNotEmpty) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              SaveButton(
                onPressed: _isLoading ? null : _saveChanges,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}