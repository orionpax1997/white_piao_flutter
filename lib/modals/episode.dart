// 集
class Episode {
  /// 标题
  String? title;

  /// 视频流地址
  String? streamUrl;

  Episode({
    this.title,
    this.streamUrl,
  });
}

class EpisodeBuilder {
  final Episode _episode = Episode();

  EpisodeBuilder title(String title) {
    _episode.title = title;
    return this;
  }

  EpisodeBuilder streamUrl(String streamUrl) {
    _episode.streamUrl = streamUrl;
    return this;
  }

  Episode build() => _episode;
}
