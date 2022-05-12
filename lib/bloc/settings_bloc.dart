import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:white_piao/context/dio_context.dart';
import 'package:white_piao/repository/expression_repository.dart';
import 'package:white_piao/repository/source_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static final Dio _dio = DioContext.getDio();
  static final SourceRepository _sourceRepository = SourceRepository.get();
  static final ExpressionRepository _expressionRepository =
      ExpressionRepository.get();

  SettingsBloc() : super(const SettingsInitial()) {
    on<SettingSourceImported>(_onSettingSourceImported,
        transformer: droppable());
  }

  Future<void> _onSettingSourceImported(
    SettingSourceImported event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final response = await _dio.get(event.url);
      if (response.statusCode == HttpStatus.ok) {
        final data = response.data as List<dynamic>;
        await _sourceRepository.importSources(data, event.url);
        _expressionRepository.clearExecutableSources();
        emit(state.copyWith(loading: false));
      } else {
        emit(state.copyWith(loading: false));
        ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
          content: Text('资源地址请求失败'),
        ));
      }
    } catch (e) {
      emit(state.copyWith(loading: false));
      ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
        content: Text('资源导入失败'),
      ));
      rethrow;
    }
  }
}
