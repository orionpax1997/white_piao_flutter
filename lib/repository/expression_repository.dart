import 'package:white_piao/context/expression_context.dart';
import 'package:white_piao/modals/discovery.dart';
import 'package:white_piao/modals/source.dart';
import 'package:white_piao/provider/source_provider.dart';

class ExpressionRepository {
  static final ExpressionRepository _expressionRepository =
      ExpressionRepository._internal();
  static final SourceProvider _sourceProvider = SourceProvider.get();
  static List<Source>? executableSources;
  static Map<int, Source>? executableSourceMap;

  ExpressionRepository._internal();

  static ExpressionRepository get() {
    return _expressionRepository;
  }

  Future<List<Source>> getExecutableSources() async {
    if (executableSources == null) {
      await loadExecutableSources();
    }
    return executableSources!;
  }

  Future<Map<int, Source>> getExecutableSourcesMap() async {
    if (executableSourceMap == null) {
      await loadExecutableSources();
    }
    return executableSourceMap!;
  }

  Future<void> loadExecutableSources() async {
    final sources = await _sourceProvider.readEnabledList();
    executableSources = sources
        .map((source) => source.copy(
            searchExpressionList: parse(source.searchExpression),
            loadSeriesExpressionList: parse(source.loadSeriesExpression),
            findStreamExpressionList: parse(source.findStreamExpression)))
        .toList();
    executableSourceMap =
        Map.fromIterable(executableSources!, key: (source) => source.id);
  }

  void clearExecutableSources() {
    executableSources = null;
    executableSourceMap = null;
  }

  Future<List<Discovery>> evalSearchExpressions(
      Source source, String keyword) async {
    final context = {'keyword': keyword, ...ExpressionContext.originalContext};
    final discoverys =
        ((await eval(source.searchExpressionList!, context)) as List)
            .cast<Discovery>();
    return discoverys.map((d) => d.copy(source: source)).toList();
  }

  Future<List> evalLoadSeriesExpression(Source source, String seriesUrl) async {
    final url =
        seriesUrl.startsWith('http') ? seriesUrl : source.host + seriesUrl;
    final context = {'seriesUrl': url, ...ExpressionContext.originalContext};
    return await eval(source.loadSeriesExpressionList!, context) as List;
  }

  Future<String> evalFindStreamExpression(
      Source source, String streamUrl) async {
    final url =
        streamUrl.startsWith('http') ? streamUrl : source.host + streamUrl;
    final context = {'streamUrl': url, ...ExpressionContext.originalContext};
    return await eval(source.findStreamExpressionList!, context) as String;
  }

//   Future<String> evalFindStreamExpression() async {
//     const url = 'https://www.ttsp.tv/vodplay/504873-4-1.html';
//     const expression = '''
// document = getDocument(streamUrl);
// str = stringMatch('(?<=},"url":")[^&"]*', document.body.outerHtml);
// str.replaceAll(_backslash, "")
// ''';
//     final context = {'streamUrl': url, ...ExpressionContext.originalContext};
//     final result = await eval(parse(expression), context) as String;
//     return result as String;
//   }
}
