part of 'groups_bloc.dart';

sealed class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupsEvent {
  final String uid;
  const LoadGroups(this.uid);
}
