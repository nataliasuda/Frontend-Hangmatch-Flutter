import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/services/friend_service.dart';
import 'package:hangmatch/widgets/gradient_button.dart';
import 'package:hangmatch/widgets/invite_friend_tile.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final TextEditingController searchController = TextEditingController();
  final FriendService friendService = FriendService();

  List<Friend> friends = [];
  List<Friend> filteredFriends = [];
  Set<String> selected = {};
  bool isLoading = true;

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

  void _toggleFriendSelection(String friendId) {
    setState(() {
      if (selected.contains(friendId)) {
        selected.remove(friendId);
      } else {
        selected.add(friendId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Choose friends to create session",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
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
                              isSelected: selected.contains(friend.id),
                              onSelected:
                                  () => _toggleFriendSelection(friend.id),
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
            GradientButton(
              text: 'INVITE',
              onPressed: () {},
              width: 200,
              height: 63,
            ),
            const SizedBox(height: 16),

            if (selected.isNotEmpty)
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
