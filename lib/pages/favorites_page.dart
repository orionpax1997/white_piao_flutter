import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/bloc/favorites_bloc.dart';
import 'package:white_piao/components/favorite_item.dart';
import 'package:white_piao/components/raw_keyboard_groups.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc.get()..add(FavoriteListLoaded()),
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return state.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RawKeyboardGroups(
                  onConfirm: (widget, x, y) => Navigator.of(context).pushNamed(
                      'series_page',
                      arguments: state.byId[state.favorites.toList()[y][x]]),
                  children: state.favorites
                      .map((l) => l
                          .map((f) => InkWell(
                              focusNode: FocusNode(skipTraversal: true),
                              onTap: () => Navigator.of(context).pushNamed(
                                  'series_page',
                                  arguments: state.byId[f]!),
                              child: FavoriteItem(favorite: state.byId[f]!)))
                          .toList())
                      .toList());
        },
      ),
    );
  }
}
