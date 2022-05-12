part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final bool loading;
  final Iterable<List<int>> favorites;
  final Map<int, Favorite> byId;

  const FavoritesState(
      {required this.loading, required this.favorites, required this.byId});

  FavoritesState copyWith({
    bool? loading,
    Iterable<List<int>>? favorites,
    Map<int, Favorite>? byId,
  }) {
    return FavoritesState(
      loading: loading ?? this.loading,
      favorites: favorites ?? this.favorites,
      byId: byId ?? this.byId,
    );
  }

  @override
  List<Object> get props => [loading, favorites, byId];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial()
      : super(loading: false, favorites: const [], byId: const {});
}
