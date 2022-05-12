import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/iterables.dart';
import 'package:white_piao/modals/favorite.dart';
import 'package:white_piao/repository/favorite_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  static FavoritesBloc _favoritesBloc = FavoritesBloc();
  static final FavoriteRepository _favoriteRepository =
      FavoriteRepository.get();

  FavoritesBloc() : super(const FavoritesInitial()) {
    on<FavoriteListLoaded>(_onFavoriteListLoaded, transformer: droppable());
  }

  static FavoritesBloc get() {
    if (_favoritesBloc.isClosed) {
      _favoritesBloc = FavoritesBloc();
    }
    return _favoritesBloc;
  }

  Future<void> _onFavoriteListLoaded(
    FavoriteListLoaded event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final partitionSize =
          window.physicalSize.width < window.physicalSize.height ? 2 : 6;
      final favorites = await _favoriteRepository.getFavorites();
      final partitionFavorites =
          partition(favorites.map((s) => s.id!).toList(), partitionSize);
      emit(state.copyWith(
          loading: false,
          favorites: partitionFavorites,
          byId: {for (var s in favorites) s.id!: s}));
    } catch (e) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }
}
