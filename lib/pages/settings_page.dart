import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_piao/bloc/settings_bloc.dart';
import 'package:white_piao/components/focus_node_wrap.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FocusNodeWrap(
                      child: ListTile(
                          focusNode: FocusNode(skipTraversal: true),
                          onTap: () => _onImportButtonClick(context),
                          leading: const Icon(Icons.network_check),
                          title: const Text('从网络地址导入')),
                      onClick: () => _onImportButtonClick(context)),
                  FocusNodeWrap(
                      child: ListTile(
                          focusNode: FocusNode(skipTraversal: true),
                          onTap: () => _onSourceManageButtonClick(context),
                          leading: const Icon(Icons.source),
                          title: const Text('资源管理')),
                      onClick: () => _onSourceManageButtonClick(context)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onImportButtonClick(BuildContext context) async {
    final url = await _showNextworkSourceImportDialog(context);
    if (url != null) {
      context.read<SettingsBloc>().add(SettingSourceImported(url, context));
    }
  }

  void _onSourceManageButtonClick(BuildContext context) async {
    Navigator.of(context).pushNamed('sources_page');
  }

  Future<String?> _showNextworkSourceImportDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('从网络地址导入'),
            content: TextField(
              controller: TextEditingController(
                  text:
                      "https://my-json-server.typicode.com/Humble-Xiang/white-piao-sources/sources"),
              onSubmitted: (text) => Navigator.pop(context, text),
              decoration: const InputDecoration(hintText: "请输入网络地址"),
            ),
          );
        });
  }
}
