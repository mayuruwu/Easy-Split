import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_split/models/group_model.dart';
import 'package:easy_split/models/group_repository.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupRepository repository;

  GroupsBloc(this.repository) : super(GroupsInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupsLoading());
      try {
        final groups = await repository.fetchGroups(event.uid);
        emit(GroupsLoaded(groups));
      } catch (e) {
        emit(GroupsError(e.toString()));
      }
    });
  }
}
