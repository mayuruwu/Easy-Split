import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GroupNameEvent {}

class NameChanged extends GroupNameEvent {
  final String name;
  NameChanged(this.name);
}

class GroupNameState {
  final bool isChecking;
  final String? error;

  GroupNameState({this.isChecking = false, this.error});

  GroupNameState copyWith({bool? isChecking, String? error}) {
    return GroupNameState(
      isChecking: isChecking ?? this.isChecking,
      error: error,
    );
  }
}

class GroupNameBloc extends Bloc<GroupNameEvent, GroupNameState> {
  GroupNameBloc() : super(GroupNameState()) {
    on<NameChanged>(_onNameChanged);
  }

  void _onNameChanged(NameChanged event, Emitter<GroupNameState> emit) {
    final name = event.name.trim();
    debugPrint("\v\v\vChecking name: $name");

    if (name.length < 3) {
      emit(
        state.copyWith(
          isChecking: false,
          error: "Name should be at least 3 characters",
        ),
      );

      return;
    } else {
      emit(state.copyWith(isChecking: false, error: null));
    }
  }
}
