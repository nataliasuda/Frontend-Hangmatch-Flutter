import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hangmatch/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSection extends StatefulWidget {
  final String? currentAvatarUrl;
  final Function(String?) onAvatarChanged;

  const AvatarSection({
    super.key,
    this.currentAvatarUrl,
    required this.onAvatarChanged,
  });

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  final UserService _userService = UserService();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );

    if (image != null) {
      await _uploadImage(File(image.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isLoading = true);
    try {
      final response = await _userService.updateAvatar(imageFile);
      widget.onAvatarChanged(response['avatar_url']);
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[800],
                backgroundImage:
                    widget.currentAvatarUrl != null
                        ? NetworkImage(
                          '${_userService.baseUrl}${widget.currentAvatarUrl!}',
                        )
                        : null,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : widget.currentAvatarUrl == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
              ),
              if (!_isLoading)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.deepPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Tap to change avatar',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
