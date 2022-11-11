// ignore_for_file: unnecessary_string_escapes

import 'package:test/test.dart';
import 'package:white_piao/context/expression_context.dart';
import 'package:white_piao/modals/discovery.dart';

void main() {
  group('天天视频', () {
    test('searchExpression', () async {
      const searchExpression = '''
document=getDocument('https://www.ttsp.tv/vodsearch/-------------.html?wd='+keyword);
list=document.querySelectorAll('.searchlist_item');
discoveries=map(list,'
  discoveryBuilder()
    .title(_item.querySelector(\"a\").attributes[\"title\"])
    .seriesUrl(_item.querySelector(\"a\").attributes[\"href\"])
    .type(_item.querySelector(\".info_right\").text)
    .actors(_item.querySelector(\".vodlist_sub\").text)
    .intro(_item.querySelectorAll(\".vodlist_sub\")[2].text)
    .image(_item.querySelector(\".vodlist_thumb\").attributes[\"data-original\"])
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
list1=document.querySelectorAll('.play_source_tab>a');
mapPayload(list1, document, '
  episodes=_payload.querySelectorAll(\".play_list_box>.playlist_full\")[_index].querySelectorAll(\"a\");
  episodeGroupBuilder()
    .title(_item.attributes[\"alt\"])    
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
        'seriesUrl': 'https://www.ttsp.tv/voddetail/504873.html',
        ...ExpressionContext.originalContext
      };
      final list = await eval(parse(loadSeriesExpression), context) as List;
      expect(list, isNotEmpty);
    });

    test('findStreamExpression', () async {
      const findStreamExpression = '''
document=getDocument(streamUrl);
str=stringMatch('(?<=},\"url\":\")[^&\"]*',document.body.outerHtml);
str.replaceAll(_backslash,\"\");
''';
      final context = {
        'streamUrl': 'https://www.ttsp.tv/vodplay/504873-6-1.html',
        ...ExpressionContext.originalContext
      };
      final stream = await eval(parse(findStreamExpression), context) as String;
      expect(stream, isNotEmpty);
    });
  });
}
