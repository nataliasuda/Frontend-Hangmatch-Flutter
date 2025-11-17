import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> friends = ["Zuzia S", "Tatiana", "Natalia"];

  List<String> filteredFriends = [];
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
  }

  void filterFriends(String query) {
    setState(() {
      filteredFriends =
          friends
              .where((name) => name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  Widget _buildFriendTile(String name) {
    final isSelected = selected.contains(name);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.purpleAccent.shade100),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) {
            setState(() {
              if (isSelected) {
                selected.remove(name);
              } else {
                selected.add(name);
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
              hintText: "Choose your friends...",
              onChanged: filterFriends,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  return _buildFriendTile(filteredFriends[index]);
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
