import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:white_piao/modals/source.dart';
import 'package:white_piao/repository/expression_repository.dart';
import 'package:white_piao/repository/source_repository.dart';

part 'sources_event.dart';
part 'sources_state.dart';

class SourcesBloc extends Bloc<SourcesEvent, SourcesState> {
  static final SourceRepository _sourceRepository = SourceRepository.get();
  static final ExpressionRepository _expressionRepository =
      ExpressionRepository.get();

  SourcesBloc() : super(const SourcesInitial()) {
    on<SourceListLoaded>(_onSourceListLoaded, transformer: droppable());
    on<SourceSwitchToggled>(_onSourceSwitchToggled, transformer: droppable());
  }

  Future<void> _onSourceListLoaded(
    SourceListLoaded event,
    Emitter<SourcesState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final sources = await _sourceRepository.getSources();
      emit(state.copyWith(
          loading: false,
          sources: sources.map((s) => s.id!).toList(),
          byId: {for (var s in sources) s.id!: s}));
    } catch (e) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }

  Future<void> _onSourceSwitchToggled(
    SourceSwitchToggled event,
    Emitter<SourcesState> emit,
  ) async {
    final isEnable = event.source.isEnable == 0 ? 1 : 0;
    final source = event.source.copy(isEnable: isEnable);
    try {
      await _sourceRepository.updateSource(source);
      _expressionRepository.clearExecutableSources();
      emit(state.copyWith(byId: {...state.byId, source.id!: source}));
    } catch (e) {
      rethrow;
    }
  }
}
