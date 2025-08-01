import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/ml/models/kmean_request_model.dart';
import 'package:frontend/modules/ml/models/kmean_response_model.dart';
import 'package:frontend/modules/ml/services/ml_services.dart';

part 'ml_state.dart';
part 'ml_event.dart';

class MlBloc extends Bloc<MLEvent, MLState> {
  MlBloc() : super(MLStateInitial()) {
    on<MLEventRunKMeans>(_onMLEventRunKMeans);
  }

  final _mlService = MLServices();

  Future<void> _onMLEventRunKMeans(
    MLEventRunKMeans event,
    Emitter<MLState> emit,
  ) async {
    emit(const MLStateLoading(message: "Running K-Means clustering..."));
    try {
      final request = KMeansRequestModel(
        datasetId: event.datasetId,
        featureX: event.featureX,
        featureY: event.featureY,
        nClusters: event.nClusters,
      );
      final response = await _mlService.runKMeans(request);

      emit(
        MlStateKMeansLoaded(
          kmeansResponse: response,
          featureX: event.featureX,
          featureY: event.featureY,
        ),
      );
    } catch (e) {
      emit(MlStateError(error: e.toString()));
    }
  }
}
