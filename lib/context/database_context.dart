import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:white_piao/modals/source.dart';
import 'package:white_piao/modals/favorite.dart';

const version = 11;

const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
const textType = 'TEXT NOT NULL';
const integerType = 'INTEGER NOT NULL';
const textNullType = 'TEXT';
const integerNullType = 'INTEGER';

class DatabaseContext {
  static final DatabaseContext _databaseContext = DatabaseContext._internal();
  static Database? _database;

  DatabaseContext._internal();

  static DatabaseContext get() {
    return _databaseContext;
  }

  Future<Database> getDatabase() async {
    if (_database == null) await _init();
    return _database!;
  }

  Future _init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "white_piao.db");

    _database = await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      await _createSourcesTable(db);
      await _createFavoritesTable(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute("DROP TABLE $sourceTableName");
      await db.execute("DROP TABLE $favoriteTableName");
      await _createSourcesTable(db);
      await _createFavoritesTable(db);
    });
  }

  Future _createSourcesTable(Database db) async {
    return await db.execute('''
CREATE TABLE $sourceTableName ( 
  ${SourceFields.id} $idType, 
  ${SourceFields.name} $textType,
  ${SourceFields.host} $textType,
  ${SourceFields.groupName} $textType,
  ${SourceFields.searchExpression} $textType,
  ${SourceFields.loadSeriesExpression} $textType,
  ${SourceFields.findStreamExpression} $textType,
  ${SourceFields.importUrl} $textType,
  ${SourceFields.isEnable} $integerType
  )
''');
  }

  Future _createFavoritesTable(Database db) async {
    return await db.execute('''
CREATE TABLE $favoriteTableName ( 
  ${FavoriteFields.id} $idType, 
  ${FavoriteFields.title} $textType,
  ${FavoriteFields.seriesUrl} $textType,
  ${FavoriteFields.sourceId} $integerType,
  ${FavoriteFields.isAutoLoadSeries} $integerType,
  ${FavoriteFields.type} $textNullType,
  ${FavoriteFields.actors} $textNullType,
  ${FavoriteFields.intro} $textNullType,
  ${FavoriteFields.image} $textNullType,
  ${FavoriteFields.createTime} $textType,
  ${FavoriteFields.lastWatchTime} $textNullType,
  ${FavoriteFields.lastWatchGroupIndex} $integerNullType,
  ${FavoriteFields.lastWatchSeriesIndex} $integerNullType
  )
''');
  }
}
