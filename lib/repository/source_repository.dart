import 'package:white_piao/modals/source.dart';
import 'package:white_piao/provider/source_provider.dart';

class SourceRepository {
  static final SourceRepository _sourceRepository =
      SourceRepository._internal();
  static final SourceProvider _sourceProvider = SourceProvider.get();

  SourceRepository._internal();

  static SourceRepository get() {
    return _sourceRepository;
  }

  Future importSources(List<dynamic> sources, String importUrl) async {
    await Future.forEach(sources, (source) async {
      source as Map<String, dynamic>;
      source['importUrl'] = importUrl;
      final primitive = await _sourceProvider.readByImportUrlAndHost(
          source['importUrl'], source['host']);
      if (primitive == null) {
        await _sourceProvider.create(Source.fromMap(source));
      } else {
        await _sourceProvider
            .update(Source.fromMap(source).copy(id: primitive.id));
      }
    });
  }

  Future<List<Source>> getSources() async {
    return _sourceProvider.readList();
  }

  Future<int> updateSource(Source source) async {
    return _sourceProvider.update(source);
  }
}
