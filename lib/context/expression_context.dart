import 'package:dio/dio.dart';
import 'package:expressions/expressions.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as paser;
import 'package:white_piao/context/dio_context.dart';
import 'package:white_piao/modals/discovery.dart';
import 'package:white_piao/modals/episode.dart';
import 'package:white_piao/modals/episode_group.dart';

final evaluator = AsyncExpressionEvaluator(memberAccessors: [
  _stringMemberAccessor,
  _listMemberAccessor,
  _documentMemberAccessor,
  _elementMemberAccessor,
  _discoveryBuilderMemberAccessor,
  _episodeBuilderMemberAccessor,
  _episodeGroupMemberAccessor,
  _episodeGroupBuilderMemberAccessor
]);

Future<dynamic> eval(
    List<Expression> expressions, Map<String, dynamic> context) async {
  for (var i = 0; i < expressions.length; i++) {
    if (i == expressions.length - 1) {
      return await evaluator.eval(expressions[i], context).single;
    } else {
      await evaluator.eval(expressions[i], context).single;
    }
  }
}

List<Expression> parse(String expression) {
  return _parse(
      expression.replaceAll(RegExp('\\s'), '').replaceAll('_space_', ' '));
}

List<Expression> _parse(String expression) {
  final expressions =
      expression.split(RegExp(";(?=([^\"']*[\"'][^\"']*[\"'])*[^\"']*\$)"));
  expressions.removeWhere((element) => element.isEmpty);
  return expressions.map((element) => Expression.parse(element)).toList();
}

class ExpressionContext {
  static final Dio _dio = DioContext.getDio();
  static final originalContext = {
    '_backslash': '\\',
    'each': each,
    'eachPayload': eachPayload,
    'map': map,
    'mapPayload': mapPayload,
    'stringMatch': stringMatch,
    'getDocument': getDocument,
    'discoveryBuilder': discoveryBuilder,
    'episodeBuilder': episodeBuilder,
    'episodeGroupBuilder': episodeGroupBuilder,
  };

  static Future<List<dynamic>> map(
      List<dynamic> list, String expression) async {
    final expressions = _parse(expression);
    final result = [];

    for (var i = 0; i < list.length; i++) {
      final context = {'_item': list[i], '_index': i, ...originalContext};
      result.add(await eval(expressions, context));
    }

    return result;
  }

  static Future<List<dynamic>> mapPayload(
      List<dynamic> list, dynamic payload, String expression) async {
    final expressions = parse(expression);
    final result = [];

    for (var i = 0; i < list.length; i++) {
      final context = {
        '_payload': payload,
        '_item': list[i],
        '_index': i,
        ...originalContext
      };
      result.add(await eval(expressions, context));
    }

    return result;
  }

  static Future<void> each(List<dynamic> list, String expression) async {
    final expressions = parse(expression);

    for (var i = 0; i < list.length; i++) {
      final context = {'_item': list[i], '_index': i, ...originalContext};
      await eval(expressions, context);
    }
  }

  static Future<void> eachPayload(
      List<dynamic> list, dynamic payload, String expression) async {
    final expressions = parse(expression);

    for (var i = 0; i < list.length; i++) {
      final context = {
        '_payload': payload,
        '_item': list[i],
        '_index': i,
        ...originalContext
      };
      await eval(expressions, context);
    }
  }

  static String stringMatch(String regExp, String input) {
    final stringMatch = RegExp(regExp).stringMatch(input);
    return stringMatch ?? '';
  }

  static Future<Document> getDocument(String url) async {
    final response = await _dio.request(url,
        options: Options(headers: {
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36',
          'Connection': 'keep-alive',
        }));
    return paser.parse(response.data);
  }

  static DiscoveryBuilder discoveryBuilder() {
    return DiscoveryBuilder();
  }

  static EpisodeBuilder episodeBuilder() {
    return EpisodeBuilder();
  }

  static EpisodeGroupBuilder episodeGroupBuilder() {
    return EpisodeGroupBuilder();
  }
}

final _stringMemberAccessor = MemberAccessor<String>({
  'replaceAll': (v) => v.replaceAll,
});

final _listMemberAccessor = MemberAccessor<List>({
  'sublist': (v) => v.sublist,
});

final _documentMemberAccessor = MemberAccessor<Document>({
  'body': (v) => v.body,
  'querySelector': (v) => v.querySelector,
  'querySelectorAll': (v) => v.querySelectorAll,
});

final _elementMemberAccessor = MemberAccessor<Element>({
  'text': (v) => v.text,
  'outerHtml': (v) => v.outerHtml,
  'attributes': (v) => v.attributes,
  'querySelector': (v) => v.querySelector,
  'querySelectorAll': (v) => v.querySelectorAll,
});

final _discoveryBuilderMemberAccessor = MemberAccessor<DiscoveryBuilder>({
  'build': (v) => v.build,
  'title': (v) => v.title,
  'seriesUrl': (v) => v.seriesUrl,
  'type': (v) => v.type,
  'actors': (v) => v.actors,
  'intro': (v) => v.intro,
  'image': (v) => v.image,
});

final _episodeBuilderMemberAccessor = MemberAccessor<EpisodeBuilder>({
  'build': (v) => v.build,
  'title': (v) => v.title,
  'streamUrl': (v) => v.streamUrl,
});

final _episodeGroupMemberAccessor = MemberAccessor<EpisodeGroup>({
  'title': (v) => v.title,
  'episodes': (v) => v.episodes,
});

final _episodeGroupBuilderMemberAccessor = MemberAccessor<EpisodeGroupBuilder>({
  'build': (v) => v.build,
  'title': (v) => v.title,
  'episodes': (v) => v.episodes,
});
