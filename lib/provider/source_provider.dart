import 'package:sqflite/sqflite.dart';
import 'package:white_piao/modals/source.dart';
import 'package:white_piao/context/database_context.dart';

class SourceProvider {
  static final SourceProvider _sourceProvider = SourceProvider._internal();
  static final DatabaseContext _databaseContext = DatabaseContext.get();

  SourceProvider._internal();

  static SourceProvider get() {
    return _sourceProvider;
  }

  Future create(Source source) async {
    final db = await _databaseContext.getDatabase();
    final id = await db.insert(sourceTableName, source.toMap());
    return source.copy(id: id);
  }

  Future<Source> read(int id) async {
    final db = await _databaseContext.getDatabase();

    final maps = await db.query(
      sourceTableName,
      columns: SourceFields.values,
      where: '${SourceFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Source.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Source?> readByImportUrlAndHost(String importUrl, String host) async {
    final db = await _databaseContext.getDatabase();

    final maps = await db.query(
      sourceTableName,
      columns: SourceFields.values,
      where: '${SourceFields.importUrl} = ? and ${SourceFields.host} = ?',
      whereArgs: [importUrl, host],
    );

    if (maps.isNotEmpty) {
      return Source.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Source>> readList() async {
    final db = await _databaseContext.getDatabase();
    final maps = await db.query(sourceTableName);
    return maps.map((map) => Source.fromMap(map)).toList();
  }

  Future<List<Source>> readEnabledList() async {
    final db = await _databaseContext.getDatabase();
    final maps = await db.query(sourceTableName,
        where: '${SourceFields.isEnable} = ?', whereArgs: [1]);
    return maps.map((map) => Source.fromMap(map)).toList();
  }

  Future<int> update(Source source) async {
    final db = await _databaseContext.getDatabase();

    return db.update(
      sourceTableName,
      source.toMap(),
      where: '${SourceFields.id} = ?',
      whereArgs: [source.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await _databaseContext.getDatabase();

    return await db.delete(
      sourceTableName,
      where: '${SourceFields.id} = ?',
      whereArgs: [id],
    );
  }
}
