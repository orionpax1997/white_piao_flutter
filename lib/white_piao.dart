import 'package:flutter/material.dart';
import 'package:white_piao/components/tv_tab_bar.dart';
import 'package:white_piao/pages/discoveries_page.dart';
import 'package:white_piao/pages/favorites_page.dart';
import 'package:white_piao/pages/player_page.dart';
import 'package:white_piao/pages/search_page.dart';
import 'package:white_piao/pages/series_page.dart';
import 'package:white_piao/pages/settings_page.dart';
import 'package:white_piao/pages/sources_page.dart';

class WhitePiaoApp extends StatelessWidget {
  const WhitePiaoApp({Key? key}) : super(key: key);

  static const String _title = '白嫖';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: const TvTabBar(
            tabs: <Widget>[
              Tab(
                text: '收藏',
                icon: Icon(Icons.favorite),
              ),
              Tab(
                text: '搜索',
                icon: Icon(Icons.search),
              ),
              Tab(
                text: '设置',
                icon: Icon(Icons.settings),
              ),
            ],
          )),
          body: const TabBarView(
            children: <Widget>[
              FavoritesPage(),
              SearchPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
      routes: {
        "sources_page": (context) => const SourcesPage(),
        "discoveries_page": (context) => const DiscoveriesPage(),
        "series_page": (context) => const SeriesPage(),
        "player_page": (context) => const PlayerPage()
      },
    );
  }
}
