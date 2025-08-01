part of 'ml_bloc.dart';

abstract class MLState extends Equatable {
  const MLState();

  @override
  List<Object?> get props => [];
}

class MLStateInitial extends MLState {
  const MLStateInitial();
}

class MLStateLoading extends MLState {
  final String message;

  const MLStateLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

class MlStateKMeansLoaded extends MLState {
  final KMeansResponseModel kmeansResponse;
  final String featureX;
  final String featureY;

  const MlStateKMeansLoaded({
    required this.kmeansResponse,
    required this.featureX,
    required this.featureY,
  });

  @override
  List<Object?> get props => [kmeansResponse, featureX, featureY];
}

class MlStateError extends MLState {
  final String? error;

  const MlStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
