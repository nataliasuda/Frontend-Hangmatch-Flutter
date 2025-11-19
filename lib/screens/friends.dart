import 'package:flutter/material.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/models/friend_request.dart';
import 'package:hangmatch/screens/add_friend.dart';
import 'package:hangmatch/services/friend_service.dart';
import 'package:hangmatch/widgets/manage_friends_card.dart';
import 'package:hangmatch/widgets/heading.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendService _friendService = FriendService();
  List<FriendRequest> _pendingRequests = [];
  List<Friend> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final requests = await _friendService.getMyRequests();
      final friends = await _friendService.getFriends();

      if (mounted) {
        setState(() {
          _pendingRequests =
              requests.where((r) => r.status == 'pending').toList();
          _friends = friends;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRespondToRequest(String requestId, bool accept) async {
    await _friendService.respondToRequest(context, requestId, accept);
    if (mounted) {
      await _loadData();
    }
  }

  Future<void> _handleRemoveFriend(String friendId) async {
    await _friendService.removeFriend(context, friendId);
    if (mounted) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(text: 'Friends', fontWeight: FontWeight.w600),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(39),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddFriendsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF884EE9),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(338, 61),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Add new friend',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Heading(text: 'Acceptable'),
                    const SizedBox(height: 17),

                    if (_pendingRequests.isNotEmpty) ...[
                      ..._pendingRequests.map(
                        (request) => ManageFriendsCard(
                          name: request.senderName,
                          isRemovable: false,
                          onAccept:
                              () => _handleRespondToRequest(request.id, true),
                          onReject:
                              () => _handleRespondToRequest(request.id, false),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No friend requests',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],

                    const SizedBox(height: 45),

                    const Heading(text: 'Friends'),
                    const SizedBox(height: 17),

                    if (_friends.isNotEmpty) ...[
                      ..._friends.map(
                        (friend) => ManageFriendsCard(
                          name: friend.name,
                          isRemovable: true,
                          onRemove: () => _handleRemoveFriend(friend.id),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No friends yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
