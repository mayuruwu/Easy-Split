import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_split/bloc/Groups/groups_bloc.dart';
import 'package:easy_split/models/group_model.dart';
import 'package:easy_split/models/group_repository.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupsBloc(GroupRepository(FirebaseFirestore.instance))
        ..add(
          LoadGroups(FirebaseAuth.instance.currentUser!.uid),
        ), // Replace with actual user ID
      child: Scaffold(
        appBar: AppBar(title: Text("Groups")),
        body: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            if (state is GroupsLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is GroupsLoaded) {
              return ListView(
                children: state.groups.map((g) => GroupTile(group: g)).toList(),
              );
            }

            if (state is GroupsError) {
              return Center(child: Text(state.message));
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final Group group;

  const GroupTile({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(group.name));
  }
}
