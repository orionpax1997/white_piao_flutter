import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();
    final _focusNode = FocusNode(onKey: (node, event) {
      if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
        RawKeyDownEvent rawKeyDownEvent = event;
        RawKeyEventDataAndroid rawKeyEventDataAndroid =
            rawKeyDownEvent.data as RawKeyEventDataAndroid;
        switch (rawKeyEventDataAndroid.keyCode) {
          case 19:
            FocusScope.of(context).focusInDirection(TraversalDirection.up);
            return KeyEventResult.handled;
          default:
            break;
        }
      }
      return KeyEventResult.ignored;
    });
    return Center(
      child: SizedBox(
        width: 600,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          onSubmitted: (text) {
            Navigator.of(context)
                .pushNamed('discoveries_page', arguments: text);
          },
          decoration: const InputDecoration(hintText: "让我们荡起双桨!"),
        ),
      ),
    );
  }
}
