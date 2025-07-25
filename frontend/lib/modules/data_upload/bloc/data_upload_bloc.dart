// frontend\lib\modules\data_upload\bloc\data_upload_bloc.dart

import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_req_model.dart';
import 'package:frontend/modules/data_upload/models/csv_upload_res_model.dart';
import 'package:frontend/modules/data_upload/services/data_upload_service.dart';

part 'data_upload_state.dart';
part 'data_upload_event.dart';

class DataUploadBloc extends Bloc<DataUploadEvent, DataUploadState> {
  DataUploadBloc() : super(const DataUploadStateInitial()) {
    on<DataUploadEventPickAndUploadCsvFile>(
      _onDataUploadEventPickAndUploadCsvFile,
    );
  }

  final DataUploadService _dataUploadService = DataUploadService();

  Future<void> _onDataUploadEventPickAndUploadCsvFile(
    DataUploadEventPickAndUploadCsvFile event,
    Emitter<DataUploadState> emit,
  ) async {
    emit(const DataUploadStateLoading(message: "Picking file..."));

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.single.path == null) {
      emit(const DataUploadStateInitial()); //user cancelled picking
      return;
    }

    File file = File(result.files.single.path!);
    String fileName = file.path.split('/').last;

    emit(DataUploadStateLoading(message: "Uploading '$fileName'..."));

    try {
      String csvContent = await file.readAsString();
      final request = CsvUploadReqModel(csvData: csvContent);
      final response = await _dataUploadService.uploadCsvData(request);
      emit(DataUploadStateLoaded(uploadResponse: response, fileName: fileName));
    } catch (e) {
      emit(DataUploadStateError(error: e.toString()));
    }
  }
}
