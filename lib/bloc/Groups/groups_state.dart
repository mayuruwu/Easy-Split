part of 'groups_bloc.dart';

sealed class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<Group> groups;
  GroupsLoaded(this.groups);
}

class GroupsError extends GroupsState {
  final String message;
  GroupsError(this.message);
}
