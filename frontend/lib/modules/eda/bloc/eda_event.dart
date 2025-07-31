part of "eda_bloc.dart";

abstract class EdaEvent extends Equatable {
  const EdaEvent();

  @override
  List<Object?> get props => [];
}

class EdaEventFetchNumericalColumns extends EdaEvent {
  final String datasetId;

  const EdaEventFetchNumericalColumns({required this.datasetId});

  @override
  List<Object?> get props => [datasetId];
}

class EdaEventGenerateScatterPlot extends EdaEvent {
  final String datasetId;
  final String featureX;
  final String featureY;

  const EdaEventGenerateScatterPlot({
    required this.datasetId,
    required this.featureX,
    required this.featureY,
  });

  @override
  List<Object?> get props => [datasetId, featureX, featureY];
}
