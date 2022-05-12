import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/bloc/sources_bloc.dart';
import 'package:white_piao/components/focus_node_wrap.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('资源管理'), leading: const Icon(Icons.source)),
      body: BlocProvider(
        create: (context) => SourcesBloc()..add(SourceListLoaded()),
        child: BlocBuilder<SourcesBloc, SourcesState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: ListView.builder(
                  itemCount: state.sources.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final source = state.byId[state.sources[index]]!;
                    return FocusNodeWrap(
                      child: ListTile(
                        leading: Switch(
                          focusNode: FocusNode(skipTraversal: true),
                          value: source.isEnable != 0,
                          onChanged: (bool value) {},
                        ),
                        title: Text(source.name),
                      ),
                      onClick: () {
                        context
                            .read<SourcesBloc>()
                            .add(SourceSwitchToggled(source));
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
