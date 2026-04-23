import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_split/models/group_model.dart';

class OpenGroup extends StatelessWidget {
  final String groupId;
  OpenGroup({super.key, required this.groupId});
  late final Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("groups")
              .doc(groupId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text("Group not found");
            }

            group = Group.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return Text("Welcome to ${group.name}!");
          },
        ),
      ),
    );
  }
}
