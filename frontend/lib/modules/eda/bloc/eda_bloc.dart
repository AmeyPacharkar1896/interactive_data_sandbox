// frontend/lib/modules/eda/bloc/eda_bloc.dart

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/eda/models/scatterplot_request_model.dart';
import 'package:frontend/modules/eda/models/scatterplot_response_model.dart';
import 'package:frontend/modules/eda/services/eda_service.dart';

part 'eda_event.dart'; // This refers to the file you provided
part 'eda_state.dart'; // This refers to the file you provided

class EdaBloc extends Bloc<EdaEvent, EdaState> {
  EdaBloc() : super(const EdaStateInitial()) {
    // --- CRITICAL FIX: Correctly reference the on-handlers for your event names ---
    on<EdaEventFetchNumericalColumns>(_onEdaEventFetchNumericalColumns);
    on<EdaEventGenerateScatterPlot>(_onEdaEventGenerateScatterPlot);
  }

  final _edaService = EdaService();

  Future<void> _onEdaEventFetchNumericalColumns(
    EdaEventFetchNumericalColumns event,
    Emitter<EdaState> emit,
  ) async {
    emit(const EdaStateLoading(message: "Fetching numerical columns..."));
    try {
      final response = await _edaService.getNumericalColumns(event.datasetId);
      emit(
        EdaStateNumericalColumnsLoaded(
          // Your correct state name
          numericalColumns: response.numericalColumns,
        ),
      );
    } catch (e) {
      emit(EdaStateError(error: e.toString()));
    }
  }

  Future<void> _onEdaEventGenerateScatterPlot(
    EdaEventGenerateScatterPlot event,
    Emitter<EdaState> emit,
  ) async {
    emit(const EdaStateLoading(message: "Generating scatter plot..."));
    try {
      final request = ScatterPlotRequestModel(
        // Correctly from eda_models.dart
        datasetId: event.datasetId,
        featureX: event.featureX,
        featureY: event.featureY,
      );
      final response = await _edaService.generateScatterPlot(request);
      emit(
        EdaStateScatterPlotLoaded(
          // Your correct state name
          plotResponse: response,
          featureX: event.featureX,
          featureY: event.featureY,
        ),
      );
    } catch (e) {
      emit(EdaStateError(error: e.toString()));
    }
  }
}
