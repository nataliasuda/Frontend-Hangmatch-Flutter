import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/services/friend_service.dart';

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
        filteredFriends = friends
            .where((friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()) ||
                friend.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildFriendTile(Friend friend) {
    final isSelected = selected.contains(friend.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.purpleAccent.shade100),
        title: Text(
          friend.name,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        subtitle: Text(
          friend.email,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) {
            setState(() {
              if (isSelected) {
                selected.remove(friend.id);
              } else {
                selected.add(friend.id);
              }
            });
          },
          side: BorderSide(color: Colors.purple.shade300),
          activeColor: Colors.purple,
          checkColor: Colors.white,
        ),
      ),
    );
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
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: filteredFriends.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredFriends.length,
                        itemBuilder: (context, index) {
                          return _buildFriendTile(filteredFriends[index]);
                        },
                      )
                    : const Center(
                        child: Text(
                          "No friends found",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            const SizedBox(height: 10),
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