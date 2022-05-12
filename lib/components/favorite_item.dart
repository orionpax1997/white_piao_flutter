import 'package:flutter/material.dart';
import 'package:white_piao/modals/favorite.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({Key? key, required this.favorite}) : super(key: key);

  final Favorite favorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5!.copyWith(color: Colors.white);
    return SizedBox(
      height: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(favorite.image!, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  favorite.title,
                  style: titleStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
