import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'raw_keyboard_group_state.dart';

class RawKeyboardGroupCubit extends Cubit<RawKeyboardGroupState> {
  RawKeyboardGroupCubit() : super(const RawKeyboardGroupState());

  void moveTo({
    int? x,
    int? y,
  }) {
    emit(state.copyWith(x: x, y: y));
  }
}
