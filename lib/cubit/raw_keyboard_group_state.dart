part of 'raw_keyboard_group_cubit.dart';

class RawKeyboardGroupState extends Equatable {
  const RawKeyboardGroupState({
    this.x = -1,
    this.y = -1,
  });

  final int x;
  final int y;

  RawKeyboardGroupState copyWith({
    int? x,
    int? y,
  }) {
    return RawKeyboardGroupState(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  String toString() {
    return '''RawKeyboardGroupState { x: $x, y: $y }''';
  }

  @override
  List<Object> get props => [x, y];
}
