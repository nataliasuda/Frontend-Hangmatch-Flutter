import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/services/friend_service.dart';
import 'package:hangmatch/services/session_service.dart';
import 'package:hangmatch/widgets/gradient_button.dart';
import 'package:hangmatch/widgets/invite_friend_tile.dart';

class InviteFriendScreen extends StatefulWidget {
  final String sessionId;
  final String sessionName;
  final int locationRadius;

  const InviteFriendScreen({
    super.key,
    required this.sessionId,
    required this.sessionName,
    required this.locationRadius,
  });

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final TextEditingController searchController = TextEditingController();
  final FriendService friendService = FriendService();
  final SessionService sessionService = SessionService();

  List<Friend> friends = [];
  List<Friend> filteredFriends = [];
  Set<String> selected = {};
  bool isLoading = true;
  bool isSendingInvites = false;
  bool invitesSent = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      final friendsList = await friendService.getFriends();
      setState(() {
        friends = friendsList;
        filteredFriends = friendsList;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading friends: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterFriends(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredFriends = friends;
      } else {
        filteredFriends =
            friends
                .where(
                  (friend) =>
                      friend.name.toLowerCase().contains(query.toLowerCase()) ||
                      friend.email.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _toggleFriendSelection(String friendEmail) {
    setState(() {
      if (selected.contains(friendEmail)) {
        selected.remove(friendEmail);
      } else {
        selected.add(friendEmail);
      }
    });
  }

  Future<void> _sendInvitations() async {
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one friend'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isSendingInvites = true;
    });

    try {
      await sessionService.inviteToSession(
        context: context,
        sessionId: widget.sessionId,
        friendEmails: selected.toList(),
      );

      setState(() {
        invitesSent = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          isSendingInvites = false;
        });
      }
    }
  }

  Future<void> _activateSession() async {
    await sessionService.activateSession(context, widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Invite friends to session",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session: ${widget.sessionName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Radius: ${widget.locationRadius}km',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${invitesSent ? 'Waiting for friends...' : 'Draft'}',
                    style: TextStyle(
                      color: invitesSent ? Colors.orange : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            CustomSearchBar(
              controller: searchController,
              hintText: "Search your friends...",
              onChanged: filterFriends,
            ),
            const SizedBox(height: 20),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child:
                    filteredFriends.isNotEmpty
                        ? ListView.builder(
                          itemCount: filteredFriends.length,
                          itemBuilder: (context, index) {
                            final friend = filteredFriends[index];
                            return InviteFriendTile(
                              friend: friend,
                              isSelected: selected.contains(friend.email),
                              onSelected:
                                  () => _toggleFriendSelection(friend.email),
                            );
                          },
                        )
                        : const Center(
                          child: Text(
                            "No friends found",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
              ),

            const SizedBox(height: 16),

            if (!invitesSent) ...[
              GradientButton(
                text:
                    isSendingInvites
                        ? 'SENDING INVITES...'
                        : 'SEND INVITATIONS',
                onPressed: isSendingInvites ? () {} : () => _sendInvitations(),
                width: double.infinity,
                height: 63,
              ),
            ] else ...[
              Column(
                children: [
                  GradientButton(
                    text: 'ACTIVATE SESSION',
                    onPressed: _activateSession,
                    width: double.infinity,
                    height: 63,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invitations sent! Wait for friends to join, then activate.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            if (selected.isNotEmpty && !invitesSent)
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Selected: ${selected.length} friend(s)",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
