part of 'sources_bloc.dart';

abstract class SourcesEvent extends Equatable {
  const SourcesEvent();

  @override
  List<Object> get props => [];
}

class SourceListLoaded extends SourcesEvent {}

class SourceSwitchToggled extends SourcesEvent {
  final Source source;

  const SourceSwitchToggled(this.source);

  @override
  List<Object> get props => [source];
}
