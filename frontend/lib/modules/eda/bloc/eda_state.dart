part of "eda_bloc.dart";

abstract class EdaState extends Equatable {
  const EdaState();

  @override
  List<Object?> get props => [];
}

class EdaStateInitial extends EdaState {
  const EdaStateInitial();
}

class EdaStateLoading extends EdaState {
  final String message;

  const EdaStateLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

class EdaStateNumericalColumnsLoaded extends EdaState {
  final List<String> numericalColumns;

  const EdaStateNumericalColumnsLoaded({required this.numericalColumns});

  @override
  List<Object?> get props => [numericalColumns];
}

class EdaStateScatterPlotLoaded extends EdaState {
  final ScatterPlotResponseModel plotResponse;
  final String featureX;
  final String featureY;

  const EdaStateScatterPlotLoaded({
    required this.plotResponse,
    required this.featureX,
    required this.featureY,
  });

  @override
  List<Object?> get props => [plotResponse, featureX, featureY];
}

class EdaStateError extends EdaState {
  final String? error;

  const EdaStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
