import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_split/bloc/AddFriend/add_friend_bloc.dart';
import 'package:easy_split/ui/elements/add_friend_tile.dart';

class AddMembers extends StatelessWidget {
  final String inviteLink;
  const AddMembers({super.key, required this.inviteLink});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddFriendBloc>().state;
    final int n = state.allFriends.length;
    return AlertDialog(
      title: Text('Add Members', textScaler: TextScaler.linear(0.8)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Copy Link Button
            Wrap(
              children: [
                Text(inviteLink, overflow: TextOverflow.ellipsis),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: inviteLink));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Link copied!')));
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            if (n > 0)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: n,
                itemBuilder: (context, index) {
                  final friendId = state.allFriends[index];
                  final isSelected = state.selectedFriends.contains(friendId.id);
                  return ListTile(
                    title: FriendTile(userId: friendId.id),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (_) {
                        context.read<AddFriendBloc>().add(
                          isSelected
                              ? RemoveFriend(friendId.id)
                              : AddFriend(friendId.id),
                        );
                      },
                    ),
                  );
                },
              )
            else
              (Text('No friends available to add.')),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, state.selectedFriends.toSet()),
          child: Text('Save'),
        ),
      ],
    );
  }
}
