part of 'ml_bloc.dart';

abstract class MLEvent extends Equatable {
  const MLEvent();

  @override
  List<Object?> get props => [];
}

class MLEventRunKMeans extends MLEvent {
  final String datasetId;
  final String featureX;
  final String featureY;
  final int nClusters;

  const MLEventRunKMeans({
    required this.datasetId,
    required this.featureX,
    required this.featureY,
    required this.nClusters,
  });

  @override
  List<Object?> get props => [datasetId, featureX, featureY, nClusters];
}
