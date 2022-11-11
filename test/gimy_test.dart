// ignore_for_file: unnecessary_string_escapes

import 'package:test/test.dart';
import 'package:white_piao/context/expression_context.dart';
import 'package:white_piao/modals/discovery.dart';

void main() {
  group('gimy 剧迷', () {
    test('searchExpression', () async {
      const searchExpression = '''
document=getDocument('https://gimy.app/search/-------------.html?wd='+keyword);
list=document.querySelectorAll('.details-info-min');
discoveries=map(list,'
  discoveryBuilder()
    .title(_item.querySelectorAll(\".details-info_space_a\")[0].attributes[\"title\"])
    .seriesUrl(_item.querySelectorAll(\".details-info_space_a\")[0].attributes[\"href\"])
    .type(_item.querySelectorAll(\".details-info_space_a\")[1].text)
    .actors(_item.querySelectorAll(\".details-info_space_.text\")[2].text)
    .intro(_item.querySelector(\".details-content-default\").text)
    .image(_item.querySelector(\".video-pic\").attributes[\"data-original\"])
  .build();
');
''';
      final context = {'keyword': '萌探', ...ExpressionContext.originalContext};
      final discoverys =
          ((await eval(parse(searchExpression), context)) as List)
              .cast<Discovery>();
      expect(discoverys, isNotEmpty);
    });

    test('loadSeriesExpression', () async {
      const loadSeriesExpression = '''
document=getDocument(seriesUrl);
list1=document.querySelectorAll('.gico');
mapPayload(list1, document, '
  episodes=_payload.querySelectorAll(\".playlist\")[_index].querySelectorAll(\"ul>li>a\");
  episodeGroupBuilder()
    .title(_item.text)    
    .episodes(map(episodes, \"      
      episodeBuilder()        
        .title(_item.text)        
        .streamUrl(_item.attributes[\\'href\\'])        
      .build()    
    \"))       
  .build();  
');
''';
      final context = {
        'seriesUrl': 'https://gimy.app/vod/199035.html',
        ...ExpressionContext.originalContext
      };
      final list = await eval(parse(loadSeriesExpression), context) as List;
      expect(list, isNotEmpty);
    });

    test('findStreamExpression', () async {
      const findStreamExpression = '''
document=getDocument(streamUrl);
str=stringMatch('(?<=,\"url\":\")[^\"]*',document.body.outerHtml);
str.replaceAll(_backslash,\"\");
''';
      final context = {
        'streamUrl': 'https://gimy.app/eps/199035-1-1.html',
        ...ExpressionContext.originalContext
      };
      final stream = await eval(parse(findStreamExpression), context) as String;
      expect(stream, isNotEmpty);
    });
  });
}
