import 'package:white_piao/modals/episode.dart';

class EpisodeGroup {
  /// 标题
  String? title;

  /// 视频流地址
  List<Episode>? episodes;

  EpisodeGroup({
    this.title,
    this.episodes,
  });
}

class EpisodeGroupBuilder {
  final EpisodeGroup _episodeGroup = EpisodeGroup();

  EpisodeGroupBuilder title(String title) {
    _episodeGroup.title = title;
    return this;
  }

  EpisodeGroupBuilder episodes(List<dynamic> episodes) {
    _episodeGroup.episodes = episodes.cast<Episode>();
    return this;
  }

  EpisodeGroup build() => _episodeGroup;
}
