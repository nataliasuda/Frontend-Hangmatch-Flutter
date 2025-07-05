import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/custom_search_bar.dart';
import 'package:hangmatch/widgets/heading.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Heading(text: 'Add New Friends'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
              controller: searchController,
              hintText: "Search by e-mail...",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
