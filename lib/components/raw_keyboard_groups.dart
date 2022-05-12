import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/cubit/raw_keyboard_group_cubit.dart';

typedef OnConfirm = void Function(Widget widget, int x, int y);

class RawKeyboardGroupView extends StatelessWidget {
  const RawKeyboardGroupView({
    required Key key,
    required this.children,
    required this.hasFocus,
    required this.x,
    this.decoration,
  }) : super(key: key);
  final List<Widget> children;
  final bool hasFocus;
  final int x;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: children
            .asMap()
            .entries
            .map((child) => Expanded(
                  child: Container(
                    decoration: (hasFocus && child.key == x)
                        ? decoration ??
                            const BoxDecoration(
                              color: Color.fromARGB(20, 0, 0, 0),
                            )
                        : null,
                    child: child.value,
                  ),
                ))
            .toList());
  }
}

class RawKeyboardGroups extends StatefulWidget {
  const RawKeyboardGroups(
      {Key? key, required this.children, this.decoration, this.onConfirm})
      : super(key: key);
  final List<List<Widget>> children;
  final Decoration? decoration;
  final OnConfirm? onConfirm;

  @override
  State<StatefulWidget> createState() {
    return _RawKeyboardGroupsState();
  }
}

class _RawKeyboardGroupsState extends State<RawKeyboardGroups> {
  final FocusNode _focusNode =
      FocusNode(onKey: (_node, _event) => KeyEventResult.handled);
  final RawKeyboardGroupCubit rawKeyboardGroupCubit = RawKeyboardGroupCubit();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        rawKeyboardGroupCubit.moveTo(x: 0, y: 0);
      } else {
        rawKeyboardGroupCubit.moveTo(x: -1, y: -1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey> _keys = List<GlobalKey>.generate(
        widget.children.length, (index) => GlobalKey());
    return BlocProvider(
      create: (context) => rawKeyboardGroupCubit,
      child: BlocBuilder<RawKeyboardGroupCubit, RawKeyboardGroupState>(
        builder: (context, state) {
          return RawKeyboardListener(
              focusNode: _focusNode,
              autofocus: false,
              onKey: (event) {
                if (event is RawKeyDownEvent) {
                  RawKeyEventDataAndroid data =
                      event.data as RawKeyEventDataAndroid;
                  switch (data.keyCode) {
                    case 19:
                      if (state.y > 0) {
                        Scrollable.ensureVisible(
                            _keys[state.y - 1].currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        rawKeyboardGroupCubit.moveTo(
                            x: widget.children[state.y - 1].length > state.x
                                ? state.x
                                : widget.children[state.y - 1].length - 1,
                            y: state.y - 1);
                      } else {
                        FocusScope.of(context)
                            .focusInDirection(TraversalDirection.up);
                      }
                      break;
                    case 20:
                      if (state.y < widget.children.length - 1) {
                        Scrollable.ensureVisible(
                            _keys[state.y + 1].currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        rawKeyboardGroupCubit.moveTo(
                            x: widget.children[state.y + 1].length > state.x
                                ? state.x
                                : widget.children[state.y + 1].length - 1,
                            y: state.y + 1);
                      } else {
                        FocusScope.of(context)
                            .focusInDirection(TraversalDirection.down);
                      }
                      break;
                    case 21:
                      if (state.x > 0) {
                        rawKeyboardGroupCubit.moveTo(
                            x: state.x - 1, y: state.y);
                      } else if (state.y > 0) {
                        Scrollable.ensureVisible(
                            _keys[state.y - 1].currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        rawKeyboardGroupCubit.moveTo(
                            x: widget.children[state.y - 1].length - 1,
                            y: state.y - 1);
                      }
                      break;
                    case 22:
                      if (state.x < widget.children[state.y].length - 1) {
                        rawKeyboardGroupCubit.moveTo(
                            x: state.x + 1, y: state.y);
                      } else if (state.y < widget.children.length - 1) {
                        Scrollable.ensureVisible(
                            _keys[state.y + 1].currentContext!,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        rawKeyboardGroupCubit.moveTo(x: 0, y: state.y + 1);
                      }
                      break;
                    case 23:
                    case 66:
                      widget.onConfirm!(
                          widget.children[state.y][state.x], state.x, state.y);
                      break;
                    default:
                      break;
                  }
                }
              },
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RawKeyboardGroupView(
                      key: _keys[index],
                      children: widget.children[index],
                      hasFocus: index == state.y,
                      x: state.x,
                    );
                  },
                ),
              ));
        },
      ),
    );
  }
}
