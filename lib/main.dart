import 'package:flutter/material.dart';
import 'package:white_piao/white_piao.dart';
import 'package:white_piao/white_piao_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const WhitePiaoApp()),
    blocObserver: WhitePiaoObserver(),
  );
}
