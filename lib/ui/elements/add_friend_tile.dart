import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FriendTile extends StatelessWidget {
  final String userId;
  const FriendTile({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final future = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(title: Text("Loading..."));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return ListTile(title: Text("User not found"));
        }

        final userData = snapshot.data!.data()!;
        final name = userData['name'] ?? 'Unknown';
        // pfp too
        final String? pfpUrl = userData['pfpUrl'];
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: pfpUrl != null ? NetworkImage(pfpUrl) : null,
              child: pfpUrl == null ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 10),
            Text(name),
          ],
        );
      },
    );
  }
}
