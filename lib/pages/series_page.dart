import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/bloc/series_bloc.dart';
import 'package:white_piao/bloc/favorites_bloc.dart';
import 'package:white_piao/components/tv_tab_bar.dart';
import 'package:white_piao/modals/favorite.dart';

class SeriesPage extends StatelessWidget {
  const SeriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorite = ModalRoute.of(context)!.settings.arguments as Favorite;
    return Scaffold(
        appBar: AppBar(
          title: const Text('列表'),
          leading: const Icon(Icons.list),
        ),
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) =>
                SeriesBloc.get()..add(SeriesListLoaded(favorite)),
            child: BlocBuilder<SeriesBloc, SeriesState>(
              builder: (context, state) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                        child: _buildDetail(context, state, favorite),
                      ),
                      state.loading
                          ? const Center(
                              child: LinearProgressIndicator(),
                            )
                          : const SizedBox.shrink(),
                      state.episodeGroups.isNotEmpty
                          ? _buildEpisodeGroups(context, state, favorite)
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }

  Row _buildDetail(BuildContext context, SeriesState state, Favorite favorite) {
    return Row(children: [
      SizedBox(
        width: 150,
        child: Image.network(
          favorite.image!,
          fit: BoxFit.cover,
        ),
      ),
      const Spacer(
        flex: 1,
      ),
      Expanded(
          flex: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Text(favorite.title, style: const TextStyle(fontSize: 20)),
              const Spacer(flex: 1),
              Text(favorite.actors!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, color: Colors.blueGrey)),
              const Spacer(flex: 1),
              Text(favorite.intro!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, color: Colors.blueGrey)),
              const Spacer(flex: 1),
              state.favorite.id == null
                  ? OutlinedButton.icon(
                      focusNode: _buildFavoriteButtonFocusNode(state),
                      onPressed: () {
                        SeriesBloc.get()
                            .add(SeriesFavoriteToggled(state.favorite));
                        FavoritesBloc.get().add(FavoriteListLoaded());
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text("收藏"))
                  : ElevatedButton.icon(
                      focusNode: _buildFavoriteButtonFocusNode(state),
                      onPressed: () {
                        SeriesBloc.get()
                            .add(SeriesFavoriteToggled(state.favorite));
                        FavoritesBloc.get().add(FavoriteListLoaded());
                      },
                      icon: const Icon(Icons.favorite),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.yellow[900]),
                      label: const Text("收藏")),
              const Spacer(flex: 1),
            ],
          ))
    ]);
  }

  FocusNode _buildFavoriteButtonFocusNode(SeriesState state) {
    return FocusNode(onKey: (node, event) {
      if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
        RawKeyDownEvent rawKeyDownEvent = event;
        RawKeyEventDataAndroid rawKeyEventDataAndroid =
            rawKeyDownEvent.data as RawKeyEventDataAndroid;
        switch (rawKeyEventDataAndroid.keyCode) {
          case 23:
          case 66:
            SeriesBloc.get().add(SeriesFavoriteToggled(state.favorite));
            FavoritesBloc.get().add(FavoriteListLoaded());
            break;
          default:
            break;
        }
      }
      return KeyEventResult.ignored;
    });
  }

  SizedBox _buildEpisodeGroups(
      BuildContext context, SeriesState state, Favorite favorite) {
    return SizedBox(
      height: 1000,
      child: DefaultTabController(
        initialIndex: 0,
        length: state.episodeGroups.length,
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.blue[200],
              child: TvTabBar(
                tabs:
                    state.episodeGroups.map((e) => Tab(text: e.title)).toList(),
              ),
            ),
            SizedBox(
              height: 950,
              child: TabBarView(
                children: state.episodeGroups
                    .map((g) => Wrap(
                        children: g.episodes!
                            .map((e) => OutlinedButton(
                                focusNode: FocusNode(onKey: (node, event) {
                                  if (event is RawKeyDownEvent &&
                                      event.data is RawKeyEventDataAndroid) {
                                    RawKeyDownEvent rawKeyDownEvent = event;
                                    RawKeyEventDataAndroid
                                        rawKeyEventDataAndroid = rawKeyDownEvent
                                            .data as RawKeyEventDataAndroid;
                                    switch (rawKeyEventDataAndroid.keyCode) {
                                      case 23:
                                      case 66:
                                        SeriesBloc.get().add(
                                            SeriesEpisodePlayed(
                                                favorite.sourceId,
                                                e.streamUrl!));
                                        Navigator.of(context)
                                            .pushNamed('player_page');
                                        break;
                                      default:
                                        break;
                                    }
                                  }
                                  return KeyEventResult.ignored;
                                }),
                                onPressed: () {
                                  SeriesBloc.get().add(SeriesEpisodePlayed(
                                      favorite.sourceId, e.streamUrl!));
                                  Navigator.of(context)
                                      .pushNamed('player_page');
                                },
                                child: Text(e.title!)))
                            .toList()))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
