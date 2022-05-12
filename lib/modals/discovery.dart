import 'package:white_piao/modals/source.dart';

/// 发现
class Discovery {
  /// 标题
  String? title;

  /// 目录地址
  String? seriesUrl;

  /// 类型
  String? type;

  /// 演员
  String? actors;

  /// 简介
  String? intro;

  /// 图片
  String? image;

  /// 资源
  Source? source;

  Discovery({
    this.title,
    this.seriesUrl,
    this.type,
    this.actors,
    this.intro,
    this.image,
    this.source,
  });

  Discovery copy({
    String? title,
    String? seriesUrl,
    String? type,
    String? actors,
    String? intro,
    String? image,
    Source? source,
  }) =>
      Discovery(
        title: title ?? this.title,
        seriesUrl: seriesUrl ?? this.seriesUrl,
        type: type ?? this.type,
        actors: actors ?? this.actors,
        intro: intro ?? this.intro,
        image: image ?? this.image,
        source: source ?? this.source,
      );
}

/// 发现 Builder
class DiscoveryBuilder {
  final Discovery _discovery = Discovery();

  DiscoveryBuilder title(String title) {
    _discovery.title = title;
    return this;
  }

  DiscoveryBuilder seriesUrl(String seriesUrl) {
    _discovery.seriesUrl = seriesUrl;
    return this;
  }

  DiscoveryBuilder type(String type) {
    _discovery.type = type;
    return this;
  }

  DiscoveryBuilder actors(String actors) {
    _discovery.actors = actors;
    return this;
  }

  DiscoveryBuilder intro(String intro) {
    _discovery.intro = intro;
    return this;
  }

  DiscoveryBuilder image(String image) {
    _discovery.image = image;
    return this;
  }

  Discovery build() {
    return _discovery;
  }
}
