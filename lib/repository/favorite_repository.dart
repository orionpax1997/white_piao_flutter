import 'package:white_piao/modals/favorite.dart';
import 'package:white_piao/provider/favorite_provider.dart';

class FavoriteRepository {
  static final FavoriteRepository _favoriteRepository =
      FavoriteRepository._internal();
  static final FavoriteProvider _favoriteProvider = FavoriteProvider.get();

  FavoriteRepository._internal();

  static FavoriteRepository get() {
    return _favoriteRepository;
  }

  Future<Favorite> toggle(Favorite favorite) async {
    final isFavorite = favorite.id == null ? false : true;
    if (isFavorite) {
      await _favoriteProvider.delete(favorite.id!);
      return favorite.copy(id: null);
    } else {
      return await _favoriteProvider.create(favorite);
    }
  }

  Future<List<Favorite>> getFavorites() async {
    return _favoriteProvider.readList();
  }
}
