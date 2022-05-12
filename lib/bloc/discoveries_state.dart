part of 'discoveries_bloc.dart';

class DiscoveriesState extends Equatable {
  final bool loading;
  final List<Discovery> discoveries;

  const DiscoveriesState({required this.loading, required this.discoveries});

  DiscoveriesState copyWith({
    bool? loading,
    List<Discovery>? discoveries,
  }) {
    return DiscoveriesState(
      loading: loading ?? this.loading,
      discoveries: discoveries ?? this.discoveries,
    );
  }

  @override
  List<Object> get props => [loading, discoveries];
}

class DiscoveriesInitial extends DiscoveriesState {
  const DiscoveriesInitial() : super(loading: false, discoveries: const []);
}
