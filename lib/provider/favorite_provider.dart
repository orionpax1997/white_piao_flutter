import 'package:sqflite/sqflite.dart';
import 'package:white_piao/modals/favorite.dart';
import 'package:white_piao/context/database_context.dart';

class FavoriteProvider {
  static final FavoriteProvider _favoriteProvider =
      FavoriteProvider._internal();
  static final DatabaseContext _databaseContext = DatabaseContext.get();

  FavoriteProvider._internal();

  static FavoriteProvider get() {
    return _favoriteProvider;
  }

  Future<Favorite> create(Favorite favorite) async {
    final db = await _databaseContext.getDatabase();
    final id = await db.insert(
        favoriteTableName, favorite.copy(createTime: DateTime.now()).toMap());
    return favorite.copy(id: id);
  }

  Future<Favorite> read(int id) async {
    final db = await _databaseContext.getDatabase();

    final maps = await db.query(
      favoriteTableName,
      columns: FavoriteFields.values,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Favorite.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Favorite>> readList() async {
    final db = await _databaseContext.getDatabase();
    final maps = await db.query(favoriteTableName);
    return maps.map((map) => Favorite.fromMap(map)).toList();
  }

  Future<List<Favorite>> readAutoLoadList() async {
    final db = await _databaseContext.getDatabase();
    final maps = await db.query(favoriteTableName,
        where: '${FavoriteFields.isAutoLoadSeries} = ?', whereArgs: [1]);
    return maps.map((map) => Favorite.fromMap(map)).toList();
  }

  Future<int> update(Favorite favorite) async {
    final db = await _databaseContext.getDatabase();

    return db.update(
      favoriteTableName,
      favorite.toMap(),
      where: '${FavoriteFields.id} = ?',
      whereArgs: [favorite.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await _databaseContext.getDatabase();

    return await db.delete(
      favoriteTableName,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );
  }
}
