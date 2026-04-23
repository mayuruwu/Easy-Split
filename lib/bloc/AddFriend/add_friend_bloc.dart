import 'package:bloc/bloc.dart';
import 'package:easy_split/models/member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class AddFriendEvent {}

class AddFriend extends AddFriendEvent {
  final String friendId;
  AddFriend(this.friendId);
}

class RemoveFriend extends AddFriendEvent {
  final String friendId;
  RemoveFriend(this.friendId);
}

class LoadFriends extends AddFriendEvent {
  final Completer<void>? completer;
  LoadFriends([this.completer]);
}

class AddFriendState {
  final List<Member> allFriends;
  final Set<String> selectedFriends;
  final String? userId;
  AddFriendState({
    this.userId,
    List<Member>? allFriends,
    Set<String>? selectedFriends,
  })  : allFriends = allFriends ?? const [],
        selectedFriends = selectedFriends ?? const {};

  AddFriendState copyWith({
    String? userId,
    List<Member>? allFriends,
    Set<String>? selectedFriends,
  }) {
    return AddFriendState(
      userId: userId ?? this.userId,
      allFriends: allFriends ?? this.allFriends,
      selectedFriends: selectedFriends ?? this.selectedFriends,
    );
  }
}

class AddFriendBloc extends Bloc<AddFriendEvent, AddFriendState> {
  AddFriendBloc() : super(AddFriendState()) {
    on<LoadFriends>(_onLoadFriends);
    on<AddFriend>(_onAddFriend);
    on<RemoveFriend>(_onRemoveFriend);
  }

  Future<void> fetchFriends() async {
    final completer = Completer<void>();
    add(LoadFriends(completer));
    return completer.future;
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<AddFriendState> emit,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(state.copyWith(allFriends: []));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .get();

      final friends = snapshot.docs.map((doc) {
        final data = doc.data();
        final friendId = (data['id'] ?? data['uid'] ?? doc.id).toString();
        final name = (data['name'] ?? '').toString();
        final photoUrl = data['photoUrl']?.toString();
        final upi = data['upi']?.toString();
        return Member(id: friendId, name: name, photoUrl: photoUrl, upi: upi);
      }).toList();

      emit(state.copyWith(userId: uid, allFriends: friends));
    } finally {
      event.completer?.complete();
    }
  }

  void _onAddFriend(AddFriend event, Emitter<AddFriendState> emit) {
    final updated = Set<String>.from(state.selectedFriends);
    if (!updated.add(event.friendId)) {
      updated.remove(event.friendId);
    }
    emit(state.copyWith(selectedFriends: updated));
  }

  void _onRemoveFriend(RemoveFriend event, Emitter<AddFriendState> emit) {
    final updated = Set<String>.from(state.selectedFriends);
    updated.remove(event.friendId);
    emit(state.copyWith(selectedFriends: updated));
  }
}
