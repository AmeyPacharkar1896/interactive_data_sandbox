// frontend\lib\modules\data_upload\bloc\data_upload_state.dart

part of 'data_upload_bloc.dart';

abstract class DataUploadState extends Equatable {
  const DataUploadState();

  @override
  List<Object?> get props => [];
}

class DataUploadStateInitial extends DataUploadState {
  const DataUploadStateInitial();
}

class DataUploadStateLoading extends DataUploadState {
  final String message;
  const DataUploadStateLoading({this.message = "Processing..."});

  @override
  List<Object> get props => [message];
}

class DataUploadStateLoaded extends DataUploadState {
  final CsvUploadResModel uploadResponse;
  final String fileName;

  const DataUploadStateLoaded({
    required this.uploadResponse,
    required this.fileName,
  });

  @override
  List<Object?> get props => [uploadResponse, fileName];
}

class DataUploadStateError extends DataUploadState {
  final String error;

  const DataUploadStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
