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

  Future<void> _deleteAvatar() async {
    setState(() => _isLoading = true);
    try {
      await _userService.deleteAvatar();
      widget.onAvatarChanged(null);
    } catch (e) {
    
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Delete avatar'),
          content: const Text('Are you sure you want to delete your avatar?', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70) ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAvatar();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      onLongPress: widget.currentAvatarUrl != null && !_isLoading 
          ? _showDeleteDialog 
          : null,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[800],
                backgroundImage: widget.currentAvatarUrl != null
                    ? NetworkImage('${_userService.baseUrl}${widget.currentAvatarUrl!}')
                    : null,
                child: _isLoading
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
            widget.currentAvatarUrl != null 
                ? 'Tap to change avatar, long press to delete'
                : 'Tap to select avatar',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
