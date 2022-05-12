import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:white_piao/repository/expression_repository.dart';
import 'package:white_piao/modals/discovery.dart';

part 'discoveries_event.dart';
part 'discoveries_state.dart';

class DiscoveriesBloc extends Bloc<DiscoveriesEvent, DiscoveriesState> {
  static final ExpressionRepository _expressionRepository =
      ExpressionRepository.get();

  DiscoveriesBloc() : super(const DiscoveriesInitial()) {
    on<DiscoveryListLoaded>(_onDiscoveryListLoaded, transformer: droppable());
    on<DiscoveryListAppended>(_onDiscoveryListAppended,
        transformer: droppable());
    on<DiscoveryListFinished>(_onDiscoveryListFinished,
        transformer: droppable());
  }

  Future<void> _onDiscoveryListLoaded(
    DiscoveryListLoaded event,
    Emitter<DiscoveriesState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final sources = await _expressionRepository.getExecutableSources();
      if (sources.isEmpty) {
        emit(state.copyWith(loading: false));
        ScaffoldMessenger.of(event.context)
            .showSnackBar(const SnackBar(content: Text('没有可用的资源')));
        Navigator.of(event.context).pop();
      } else {
        for (final source in sources) {
          final discoveries = await _expressionRepository.evalSearchExpressions(
              source, event.keyword);
          add(DiscoveryListAppended(discoveries));
        }
        add(DiscoveryListFinished());
      }
    } catch (e) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }

  void _onDiscoveryListAppended(
      DiscoveryListAppended event, Emitter<DiscoveriesState> emit) {
    emit(state
        .copyWith(discoveries: [...state.discoveries, ...event.discoveries]));
  }

  void _onDiscoveryListFinished(
      DiscoveryListFinished event, Emitter<DiscoveriesState> emit) {
    emit(state.copyWith(loading: false));
  }
}
