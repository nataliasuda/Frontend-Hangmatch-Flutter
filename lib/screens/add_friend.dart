import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';
import '../models/friend.dart';
import '../services/friend_service.dart';
import '../widgets/friend_tile.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FriendService friendService = FriendService();

  List<Friend> friends = [];
  bool isLoading = false;

  void onSearch(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final results = await friendService.searchFriends(query);
      setState(() {
        friends = results;
      });
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendInvite(BuildContext context, String email) async {
    try {
      await friendService.inviteFriend(context, email);
      onSearch(_searchController.text);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add New Friends'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              hintText: "Search by e-mail...",
              onChanged: onSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : friends.isNotEmpty
                      ? ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return FriendTile(
                            email: friend.email,
                            status: friend.status,
                            onAdd: () {
                              sendInvite(context, friend.email);
                            },
                          );
                        },
                      )
                      : const Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
