part of 'discoveries_bloc.dart';

abstract class DiscoveriesEvent extends Equatable {
  const DiscoveriesEvent();

  @override
  List<Object> get props => [];
}

class DiscoveryListLoaded extends DiscoveriesEvent {
  final String keyword;
  final BuildContext context;

  const DiscoveryListLoaded(this.keyword, this.context);

  @override
  List<Object> get props => [keyword, context];
}

class DiscoveryListAppended extends DiscoveriesEvent {
  final List<Discovery> discoveries;

  const DiscoveryListAppended(this.discoveries);

  @override
  List<Object> get props => [discoveries];
}

class DiscoveryListFinished extends DiscoveriesEvent {}
