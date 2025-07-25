// frontend\lib\modules\data_upload\bloc\data_upload_event.dart

part of 'data_upload_bloc.dart';

class DataUploadEvent extends Equatable {
  const DataUploadEvent();

  @override
  List<Object?> get props => [];
}

class DataUploadEventPickAndUploadCsvFile extends DataUploadEvent {
  const DataUploadEventPickAndUploadCsvFile();
}
