import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

//packages
import 'package:easy_split/ui/elements/app_bar.dart';
import 'package:easy_split/ui/elements/my_form.dart';
import 'package:easy_split/ui/elements/pfp.dart';
import 'package:easy_split/ui/elements/add_member.dart';

//firebase
import 'package:firebase_auth/firebase_auth.dart';

// bloc
import 'package:easy_split/bloc/image_picker/image_picker_bloc.dart';
import 'package:easy_split/bloc/GroupName/group_name_bloc.dart';
import 'package:easy_split/bloc/AddFriend/add_friend_bloc.dart';

class CreateGroupPage extends StatelessWidget {
  CreateGroupPage({super.key});

  final TextEditingController groupNameController = TextEditingController(),
      descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, [List<String>? selectedFriends]) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(title: "Create Group"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                BlocProvider(
                  create: (context) => ImagePickerBloc(),
                  child: Pfp(group: true),
                ),
                SizedBox(height: 20),

                const Text("Group Name"),
                BlocProvider(
                  create: (_) => GroupNameBloc(),
                  child: BlocBuilder<GroupNameBloc, GroupNameState>(
                    builder: (context, state) {
                      return TextFormField(
                        controller: groupNameController,
                        onChanged: (value) {
                          context.read<GroupNameBloc>().add(NameChanged(value));
                        },
                        decoration: InputDecoration(
                          hintText: "Easy Split",
                          hintStyle: TextStyle(
                            color: Colors.grey.withAlpha(100),
                          ),
                          errorText: state.error,
                          suffixIcon: state.isChecking
                              ? Padding(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Description"),
                TextFormField(
                  maxLines: 3,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Enter group description",
                    hintStyle: TextStyle(color: Colors.grey.withAlpha(100)),
                  ),
                ),

                const SizedBox(height: 30),
                BlocProvider(
                  create: (context) => AddFriendBloc(),
                  child: BlocBuilder<AddFriendBloc, AddFriendState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          selectedFriends != null
                              ? Wrap(
                                  runSpacing: 8,
                                  spacing: 8,

                                  children: [
                                    SizedBox(width: 10),
                                    ...selectedFriends.map(
                                      (f) => smallTile(context, f),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                )
                              : SizedBox.shrink(),
                          ElevatedButton(
                            onPressed: () async {
                              final bloc = context.read<AddFriendBloc>();
                              await bloc.fetchFriends();
                              final parentContext = context;
                              showDialog(
                                context: context,
                                builder: (context) => BlocProvider.value(
                                  value: parentContext.read<AddFriendBloc>(),
                                  child: AddMembers(
                                    inviteLink:
                                        "https://easysplit.com/invite/abc123",
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Add Members"),
                                SizedBox(width: 10),
                                Icon(Icons.group_add_outlined),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final groupName = groupNameController.text;
                      final description = descriptionController.text;
                      final image = context.read<ImagePickerBloc>().state.image;
                      showLoader(context);
                      await saveGroup(
                        groupName,
                        description,
                        image?.path,
                        selectedFriends,
                      );
                      hideLoader(context);
                      context.go('/groups');
                    },
                    child: const Text("Create Group"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget smallTile(BuildContext context, String s) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: EdgeInsets.only(right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(s),
        ),
        IconButton(
          onPressed: () {
            context.read<AddFriendBloc>().add(RemoveFriend(s));
          },
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Future<void> saveGroup(
    String groupName,
    String description,
    String? imagePath, [
    List<String>? selectedFriends,
  ]) async {
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('groups')
    //     .where('name', isEqualTo: groupName)
    //     .limit(1)
    //     .get();
    // if (snapshot.docs.isNotEmpty) {
    //   throw Exception("Group already exists");
    // }
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String uid = user.uid;
    final x = FirebaseFirestore.instance.collection('groups');
    final ref = await x.add({
      'name': groupName,
      'description': description,
      'imagePath': imagePath,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    final t = ref.collection('members');
    await t.doc(uid).set({
      'uid': uid,
      'joinedAt': FieldValue.serverTimestamp(),
      'role': 'admin',
    });

    for (var i in selectedFriends ?? []) {
      await t.doc(i).set({
        'uid': i,
        'joinedAt': FieldValue.serverTimestamp(),
        'role': 'member',
      });
    }
  }
}
