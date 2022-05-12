import 'package:white_piao/modals/discovery.dart';

const String favoriteTableName = 'favorites';

class FavoriteFields {
  static const List<String> values = [
    id,
    title,
    seriesUrl,
    sourceId,
    isAutoLoadSeries,
    type,
    actors,
    intro,
    image,
    createTime,
    lastWatchTime,
    lastWatchGroupIndex,
    lastWatchSeriesIndex
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String seriesUrl = 'seriesUrl';
  static const String sourceId = 'sourceId';
  static const String isAutoLoadSeries = 'isAutoLoadSeries';
  static const String type = 'type';
  static const String actors = 'actors';
  static const String intro = 'intro';
  static const String image = 'image';
  static const String createTime = 'createTime';
  static const String lastWatchTime = 'lastWatchTime';
  static const String lastWatchGroupIndex = 'lastWatchGroupIndex';
  static const String lastWatchSeriesIndex = 'lastWatchSeriesIndex';
}

/// 喜爱
class Favorite {
  /// 主键
  final int? id;

  /// 标题
  final String title;

  /// 目录地址
  final String seriesUrl;

  /// 资源 Id
  final int sourceId;

  /// 是否追更
  final int isAutoLoadSeries;

  /// 类型
  final String? type;

  /// 演员
  final String? actors;

  /// 简介
  final String? intro;

  /// 图片
  final String? image;

  /// 创建时间
  final DateTime? createTime;

  /// 最后观看时间
  final DateTime? lastWatchTime;

  /// 最后观看分组下标
  final int? lastWatchGroupIndex;

  /// 最后观看集数下标
  final int? lastWatchSeriesIndex;

  Favorite({
    this.id,
    required this.title,
    required this.seriesUrl,
    required this.sourceId,
    this.isAutoLoadSeries = 0,
    this.type,
    this.actors,
    this.intro,
    this.image,
    this.createTime,
    this.lastWatchTime,
    this.lastWatchGroupIndex,
    this.lastWatchSeriesIndex,
  });

  Favorite copy({
    int? id,
    String? title,
    String? seriesUrl,
    int? sourceId,
    int? isAutoLoadSeries,
    String? type,
    String? actors,
    String? intro,
    String? image,
    DateTime? createTime,
    DateTime? lastWatchTime,
    int? lastWatchGroupIndex,
    int? lastWatchSeriesIndex,
  }) =>
      Favorite(
        id: id,
        title: title ?? this.title,
        seriesUrl: seriesUrl ?? this.seriesUrl,
        sourceId: sourceId ?? this.sourceId,
        isAutoLoadSeries: isAutoLoadSeries ?? this.isAutoLoadSeries,
        type: type ?? this.type,
        actors: actors ?? this.actors,
        intro: intro ?? this.intro,
        image: image ?? this.image,
        createTime: createTime ?? this.createTime,
        lastWatchTime: lastWatchTime ?? this.lastWatchTime,
        lastWatchGroupIndex: lastWatchGroupIndex ?? this.lastWatchGroupIndex,
        lastWatchSeriesIndex: lastWatchSeriesIndex ?? this.lastWatchSeriesIndex,
      );

  // fromDiscovery
  factory Favorite.fromDiscovery(Discovery discovery) => Favorite(
        title: discovery.title!,
        seriesUrl: discovery.seriesUrl!,
        sourceId: discovery.source!.id!,
        isAutoLoadSeries: 0,
        type: discovery.type,
        actors: discovery.actors,
        intro: discovery.intro,
        image: discovery.image,
      );

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite(
        id: map[FavoriteFields.id],
        title: map[FavoriteFields.title],
        seriesUrl: map[FavoriteFields.seriesUrl],
        sourceId: map[FavoriteFields.sourceId],
        isAutoLoadSeries: map[FavoriteFields.isAutoLoadSeries],
        type: map[FavoriteFields.type],
        actors: map[FavoriteFields.actors],
        intro: map[FavoriteFields.intro],
        image: map[FavoriteFields.image],
        createTime: DateTime.parse(
          map[FavoriteFields.createTime],
        ),
        lastWatchTime: map[FavoriteFields.lastWatchTime] != null &&
                map[FavoriteFields.lastWatchTime] != ''
            ? DateTime.parse(map[FavoriteFields.lastWatchTime])
            : null,
        lastWatchGroupIndex: map[FavoriteFields.lastWatchGroupIndex],
        lastWatchSeriesIndex: map[FavoriteFields.lastWatchSeriesIndex],
      );

  Map<String, dynamic> toMap() => {
        FavoriteFields.id: id,
        FavoriteFields.title: title,
        FavoriteFields.seriesUrl: seriesUrl,
        FavoriteFields.sourceId: sourceId,
        FavoriteFields.isAutoLoadSeries: isAutoLoadSeries,
        FavoriteFields.type: type,
        FavoriteFields.actors: actors,
        FavoriteFields.intro: intro,
        FavoriteFields.image: image,
        FavoriteFields.createTime: createTime?.toIso8601String(),
        FavoriteFields.lastWatchTime:
            lastWatchTime != null ? lastWatchTime?.toIso8601String() : '',
        FavoriteFields.lastWatchGroupIndex: lastWatchGroupIndex,
        FavoriteFields.lastWatchSeriesIndex: lastWatchSeriesIndex,
      };
}
