part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool loading;

  const SettingsState({required this.loading});

  SettingsState copyWith({
    bool? loading,
  }) {
    return SettingsState(
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [loading];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial() : super(loading: false);
}
