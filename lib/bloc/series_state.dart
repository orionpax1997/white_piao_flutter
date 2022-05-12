part of 'series_bloc.dart';

class SeriesState extends Equatable {
  final bool loading;
  final Favorite favorite;
  final List<EpisodeGroup> episodeGroups;
  final List<Episode> episodes;
  final bool loadingStreamUrl;
  final String? currentPlayStreamUrl;

  const SeriesState({
    required this.loading,
    required this.favorite,
    required this.episodeGroups,
    required this.episodes,
    required this.loadingStreamUrl,
    this.currentPlayStreamUrl,
  });

  SeriesState copyWith({
    bool? loading,
    Favorite? favorite,
    List<EpisodeGroup>? episodeGroups,
    List<Episode>? episodes,
    bool? loadingStreamUrl,
    String? currentPlayStreamUrl,
  }) {
    return SeriesState(
      loading: loading ?? this.loading,
      favorite: favorite ?? this.favorite,
      episodeGroups: episodeGroups ?? this.episodeGroups,
      episodes: episodes ?? this.episodes,
      loadingStreamUrl: loadingStreamUrl ?? this.loadingStreamUrl,
      currentPlayStreamUrl: currentPlayStreamUrl ?? this.currentPlayStreamUrl,
    );
  }

  @override
  List<Object> get props =>
      [loading, favorite, episodeGroups, episodes, loadingStreamUrl];
}

class SeriesInitial extends SeriesState {
  SeriesInitial()
      : super(
            loading: false,
            favorite: Favorite(title: "", seriesUrl: "", sourceId: 0),
            episodeGroups: const [],
            episodes: const [],
            loadingStreamUrl: false,
            currentPlayStreamUrl: null);
}
