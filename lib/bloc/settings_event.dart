part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingSourceImported extends SettingsEvent {
  final String url;
  final BuildContext context;
  const SettingSourceImported(this.url, this.context);

  @override
  List<Object> get props => [url, context];
}
