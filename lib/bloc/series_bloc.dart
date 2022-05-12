import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:white_piao/modals/episode.dart';
import 'package:white_piao/modals/episode_group.dart';
import 'package:white_piao/modals/favorite.dart';
import 'package:white_piao/repository/expression_repository.dart';
import 'package:white_piao/repository/favorite_repository.dart';

part 'series_event.dart';
part 'series_state.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  static SeriesBloc _seriesBloc = SeriesBloc();
  static final ExpressionRepository _expressionRepository =
      ExpressionRepository.get();
  static final FavoriteRepository _favoriteRepository =
      FavoriteRepository.get();

  static SeriesBloc get() {
    if (_seriesBloc.isClosed) {
      _seriesBloc = SeriesBloc();
    }
    return _seriesBloc;
  }

  SeriesBloc() : super(SeriesInitial()) {
    on<SeriesListLoaded>(_onSeriesListLoaded, transformer: droppable());
    on<SeriesEpisodePlayed>(_onSeriesEpisodePlayed, transformer: droppable());
    on<SeriesFavoriteToggled>(_onSeriesFavoriteToggled,
        transformer: droppable());
  }

  Future<void> _onSeriesListLoaded(
    SeriesListLoaded event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(loading: true, favorite: event.favorite));
    try {
      final executableSourcesMap =
          await _expressionRepository.getExecutableSourcesMap();
      final list = await _expressionRepository.evalLoadSeriesExpression(
          executableSourcesMap[event.favorite.sourceId]!,
          event.favorite.seriesUrl);
      if (list.isEmpty) {
        emit(state.copyWith(loading: false));
      } else if (list[0] is EpisodeGroup) {
        emit(state.copyWith(
            loading: false, episodeGroups: list.cast<EpisodeGroup>()));
      } else {
        emit(state.copyWith(loading: false, episodes: list.cast<Episode>()));
      }
    } catch (e) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }

  Future<void> _onSeriesEpisodePlayed(
    SeriesEpisodePlayed event,
    Emitter<SeriesState> emit,
  ) async {
    emit(state.copyWith(loadingStreamUrl: true));
    try {
      final executableSourcesMap =
          await _expressionRepository.getExecutableSourcesMap();
      final streamUrl = await _expressionRepository.evalFindStreamExpression(
          executableSourcesMap[event.sourceId]!, event.streamUrl);
      emit(state.copyWith(
          loadingStreamUrl: false, currentPlayStreamUrl: streamUrl));
    } catch (e) {
      emit(state.copyWith(loadingStreamUrl: false));
      rethrow;
    }
  }

  Future<void> _onSeriesFavoriteToggled(
    SeriesFavoriteToggled event,
    Emitter<SeriesState> emit,
  ) async {
    try {
      final favorite = await _favoriteRepository.toggle(event.favorite);
      emit(state.copyWith(favorite: favorite));
    } catch (e) {
      rethrow;
    }
  }
}
