// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';

/// {@template counter_observer}
/// [BlocObserver] for the counter application which
/// observes all state changes.
/// {@endtemplate}
class WhitePiaoObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
