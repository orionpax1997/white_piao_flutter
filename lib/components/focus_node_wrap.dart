import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnFocusChange = void Function(bool hasFocus);
typedef OnClick = void Function();
typedef OnKeyDown = void Function(int keyCode);

class FocusNodeWrap extends StatefulWidget {
  const FocusNodeWrap({
    Key? key,
    required this.child,
    this.focusNode,
    this.decoration,
    this.onFocusChange,
    this.onClick,
    this.onKeyDown,
  }) : super(key: key);

  final Widget child;
  final FocusNode? focusNode;
  final BoxDecoration? decoration;
  final OnFocusChange? onFocusChange;
  final OnClick? onClick;
  final OnKeyDown? onKeyDown;

  @override
  State<StatefulWidget> createState() {
    return _FocusNodeWrapState();
  }
}

class _FocusNodeWrapState extends State<FocusNodeWrap> {
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (widget.onFocusChange != null) {
        widget.onFocusChange!(_focusNode.hasFocus);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid =
                rawKeyDownEvent.data as RawKeyEventDataAndroid;
            if (widget.onKeyDown != null) {
              widget.onKeyDown!(rawKeyEventDataAndroid.keyCode);
            }
            switch (rawKeyEventDataAndroid.keyCode) {
              case 23:
              case 66:
                if (widget.onClick != null) {
                  widget.onClick!();
                }
                break;
              default:
                break;
            }
          }
        },
        child: Container(
          decoration: _focusNode.hasFocus
              ? widget.decoration ??
                  const BoxDecoration(
                    color: Color.fromARGB(20, 0, 0, 0),
                  )
              : null,
          child: widget.child,
        ));
  }
}
