import 'package:flutter/material.dart';
import 'package:hangmatch/models/friend.dart';
import 'package:hangmatch/services/friend_service.dart';
import '../widgets/custom_search_bar.dart';
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

      final uniqueResults = {for (var f in results) f.id: f}.values.toList();

      setState(() {
        friends = uniqueResults;
      });
    } catch (e) {
      print('Error searching friends: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendInvite(BuildContext context, String email) async {
    try {
      await friendService.inviteFriend(context, email);

      setState(() {
        friends =
            friends.map((f) {
              if (f.email == email) {
                return Friend(
                  id: f.id,
                  email: f.email,
                  name: f.name,
                  status: 'pending',
                );
              }
              return f;
            }).toList();
      });
    } catch (e) {
      print('Error sending invite: $e');
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
              hintText: "Search by name...",
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
                            name: friend.name,
                            status: friend.status ?? 'not_friends',
                            onAdd: () => sendInvite(context, friend.email),
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
