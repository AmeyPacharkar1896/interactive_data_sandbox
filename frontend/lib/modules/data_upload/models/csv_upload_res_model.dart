import 'package:equatable/equatable.dart';
import 'package:frontend/modules/data_upload/models/column_info_model.dart';

class CsvUploadResModel extends Equatable {
  final String message;
  final String datasetId;
  final List<ColumnInfoModel> columnInfo;
  final List<Map<String, dynamic>> sampleData;

  const CsvUploadResModel({
    required this.message,
    required this.datasetId,
    required this.columnInfo,
    required this.sampleData,
  });

  factory CsvUploadResModel.fromJson(Map<String, dynamic> json) {
    return CsvUploadResModel(
      message: json['message'] as String,
      datasetId: json['dataset_id'] as String,
      columnInfo:
          (json['column_info'] as List<dynamic>?)
              ?.map((e) => ColumnInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sampleData:
          (json['sample_data'] as List<dynamic>?)
              ?.where((e) => e is Map<String, dynamic>)
              .map((e) {
                final Map<String, dynamic> rowMap = e as Map<String, dynamic>;
                final Map<String, dynamic> safeRowMap = {};
                rowMap.forEach((key, value) {
                  safeRowMap[key] = value?.toString() ?? '';
                });
                return safeRowMap;
              })
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [message, datasetId, columnInfo, sampleData];
}
