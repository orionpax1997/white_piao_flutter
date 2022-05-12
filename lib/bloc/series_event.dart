part of 'series_bloc.dart';

abstract class SeriesEvent extends Equatable {
  const SeriesEvent();

  @override
  List<Object> get props => [];
}

class SeriesListLoaded extends SeriesEvent {
  final Favorite favorite;

  const SeriesListLoaded(this.favorite);

  @override
  List<Object> get props => [favorite];
}

class SeriesEpisodePlayed extends SeriesEvent {
  final int sourceId;
  final String streamUrl;

  const SeriesEpisodePlayed(this.sourceId, this.streamUrl);

  @override
  List<Object> get props => [sourceId, streamUrl];
}

class SeriesFavoriteToggled extends SeriesEvent {
  final Favorite favorite;

  const SeriesFavoriteToggled(this.favorite);

  @override
  List<Object> get props => [favorite];
}
