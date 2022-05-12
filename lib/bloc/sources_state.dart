part of 'sources_bloc.dart';

class SourcesState extends Equatable {
  final bool loading;
  final List<int> sources;
  final Map<int, Source> byId;

  const SourcesState(
      {required this.loading, required this.sources, required this.byId});

  SourcesState copyWith({
    bool? loading,
    List<int>? sources,
    Map<int, Source>? byId,
  }) {
    return SourcesState(
      loading: loading ?? this.loading,
      sources: sources ?? this.sources,
      byId: byId ?? this.byId,
    );
  }

  @override
  List<Object> get props => [loading, sources, byId];
}

class SourcesInitial extends SourcesState {
  const SourcesInitial()
      : super(loading: false, sources: const [], byId: const {});
}
