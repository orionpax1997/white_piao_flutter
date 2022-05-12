import 'package:expressions/expressions.dart';

const String sourceTableName = 'sources';

/// 资源字段
class SourceFields {
  static const List<String> values = [
    id,
    name,
    host,
    groupName,
    searchExpression,
    loadSeriesExpression,
    findStreamExpression,
    importUrl,
    isEnable
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String host = 'host';
  static const String groupName = 'groupName';
  static const String searchExpression = 'searchExpression';
  static const String loadSeriesExpression = 'loadSeriesExpression';
  static const String findStreamExpression = 'findStreamExpression';
  static const String importUrl = 'importUrl';
  static const String isEnable = 'isEnable';
}

/// 资源
class Source {
  /// 主键
  final int? id;

  /// 名称
  final String name;

  /// Host
  final String host;

  /// 分组名称
  final String groupName;

  /// 发现表达式
  final String searchExpression;

  /// 加载目录表达式
  final String loadSeriesExpression;

  /// 发现流表达式
  final String findStreamExpression;

  /// 导入地址
  final String importUrl;

  /// 是否启用
  final int isEnable;

  /// 可执行发现表达式
  final List<Expression>? searchExpressionList;

  /// 可执行加载目录表达式
  final List<Expression>? loadSeriesExpressionList;

  /// 可执行发现流表达式
  final List<Expression>? findStreamExpressionList;

  const Source(
      {this.id,
      required this.name,
      required this.host,
      required this.searchExpression,
      required this.loadSeriesExpression,
      required this.findStreamExpression,
      required this.importUrl,
      this.groupName = '未分组',
      this.isEnable = 1,
      this.searchExpressionList,
      this.loadSeriesExpressionList,
      this.findStreamExpressionList});

  Source copy({
    int? id,
    String? name,
    String? host,
    String? groupName,
    String? searchExpression,
    String? loadSeriesExpression,
    String? findStreamExpression,
    String? importUrl,
    int? isEnable,
    List<Expression>? searchExpressionList,
    List<Expression>? loadSeriesExpressionList,
    List<Expression>? findStreamExpressionList,
  }) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
        host: host ?? this.host,
        groupName: groupName ?? this.groupName,
        searchExpression: searchExpression ?? this.searchExpression,
        loadSeriesExpression: loadSeriesExpression ?? this.loadSeriesExpression,
        findStreamExpression: findStreamExpression ?? this.findStreamExpression,
        importUrl: importUrl ?? this.importUrl,
        isEnable: isEnable ?? this.isEnable,
        searchExpressionList: searchExpressionList ?? this.searchExpressionList,
        loadSeriesExpressionList:
            loadSeriesExpressionList ?? this.loadSeriesExpressionList,
        findStreamExpressionList:
            findStreamExpressionList ?? this.findStreamExpressionList,
      );

  factory Source.fromMap(Map<String, dynamic> map) => Source(
        id: map[SourceFields.id],
        name: map[SourceFields.name],
        host: map[SourceFields.host],
        groupName: map[SourceFields.groupName] ?? '未分组',
        searchExpression: map[SourceFields.searchExpression],
        loadSeriesExpression: map[SourceFields.loadSeriesExpression],
        findStreamExpression: map[SourceFields.findStreamExpression],
        importUrl: map[SourceFields.importUrl],
        isEnable: map[SourceFields.isEnable] != null
            ? map[SourceFields.isEnable] is String
                ? int.parse(map[SourceFields.isEnable])
                : map[SourceFields.isEnable]
            : 1,
      );

  Map<String, dynamic> toMap() => {
        SourceFields.id: id,
        SourceFields.name: name,
        SourceFields.host: host,
        SourceFields.groupName: groupName,
        SourceFields.searchExpression: searchExpression,
        SourceFields.loadSeriesExpression: loadSeriesExpression,
        SourceFields.findStreamExpression: findStreamExpression,
        SourceFields.importUrl: importUrl,
        SourceFields.isEnable: isEnable,
      };
}
