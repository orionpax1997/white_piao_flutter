import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/bloc/discoveries_bloc.dart';
import 'package:white_piao/components/discovery_item.dart';
import 'package:white_piao/components/focus_node_wrap.dart';
import 'package:white_piao/modals/favorite.dart';

class DiscoveriesPage extends StatelessWidget {
  const DiscoveriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyword = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar:
          AppBar(title: const Text('发现'), leading: const Icon(Icons.search)),
      body: BlocProvider(
        create: (context) =>
            DiscoveriesBloc()..add(DiscoveryListLoaded(keyword, context)),
        child: BlocBuilder<DiscoveriesBloc, DiscoveriesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: state.discoveries.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final discovery = state.discoveries[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('series_page',
                              arguments: Favorite.fromDiscovery(discovery));
                        },
                        child: FocusNodeWrap(
                          child: DiscoveryItem(discovery: discovery),
                          onClick: () {
                            Navigator.of(context).pushNamed('series_page',
                                arguments: Favorite.fromDiscovery(discovery));
                          },
                        ),
                      );
                    },
                  ),
                  const LinearProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
