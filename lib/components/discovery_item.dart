import 'package:flutter/material.dart';
import 'package:white_piao/modals/discovery.dart';

class DiscoveryItem extends StatelessWidget {
  const DiscoveryItem({Key? key, required this.discovery}) : super(key: key);

  final Discovery discovery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          SizedBox(
            width: 150,
            child: Image.network(
              discovery.image!,
              fit: BoxFit.fitWidth,
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
                  const Spacer(flex: 10),
                  Text(discovery.title!, style: const TextStyle(fontSize: 20)),
                  const Spacer(flex: 2),
                  Text(discovery.actors!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.blueGrey)),
                  const Spacer(flex: 1),
                  Text(discovery.intro!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.blueGrey)),
                  const Spacer(flex: 10),
                ],
              ))
        ]),
      ),
    );
  }
}
