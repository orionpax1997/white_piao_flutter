import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class TvTabBar extends StatefulWidget implements PreferredSizeWidget {
  const TvTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
  }) : super(key: key);

  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration? indicator;
  final bool automaticIndicatorColorAdjustment;
  final TabBarIndicatorSize? indicatorSize;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final TextStyle? unselectedLabelStyle;
  final MaterialStateProperty<Color?>? overlayColor;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<int>? onTap;
  final ScrollPhysics? physics;

  @override
  Size get preferredSize {
    double maxHeight = 46.0;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  @override
  State<StatefulWidget> createState() {
    return _TvTabBarState();
  }
}

class _TvTabBarState extends State<TvTabBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context)!;
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: false,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          RawKeyEventDataAndroid data = event.data as RawKeyEventDataAndroid;
          switch (data.keyCode) {
            case 21:
              if (tabController.index > 0) {
                tabController.animateTo(tabController.index - 1);
              }
              break;
            case 22:
              if (tabController.index < tabController.length - 1) {
                tabController.animateTo(tabController.index + 1);
              }
              break;
            default:
              break;
          }
        }
      },
      child: TabBar(
          tabs: widget.tabs,
          controller: widget.controller,
          isScrollable: widget.isScrollable,
          padding: widget.padding,
          automaticIndicatorColorAdjustment:
              widget.automaticIndicatorColorAdjustment,
          indicatorColor: widget.indicatorColor,
          indicatorWeight: widget.indicatorWeight,
          indicatorPadding: widget.indicatorPadding,
          indicator: _focusNode.hasFocus
              ? BoxDecoration(
                  color: const Color.fromARGB(20, 0, 0, 0),
                  border: Border(
                      bottom: BorderSide(
                    width: widget.indicatorWeight,
                    color: Colors.white,
                  )))
              : null,
          indicatorSize: widget.indicatorSize,
          labelColor: widget.labelColor,
          labelStyle: widget.labelStyle,
          labelPadding: widget.labelPadding,
          unselectedLabelColor: widget.unselectedLabelColor,
          unselectedLabelStyle: widget.unselectedLabelStyle,
          dragStartBehavior: widget.dragStartBehavior,
          overlayColor:
              MaterialStateProperty.resolveWith((states) => Colors.blue),
          mouseCursor: widget.mouseCursor,
          enableFeedback: widget.enableFeedback,
          onTap: widget.onTap,
          physics: widget.physics),
    );
  }
}
