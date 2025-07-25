// frontend\lib\modules\data_upload\models\csv_upload_res_model.dart

import 'package:equatable/equatable.dart';
import 'package:frontend/modules/data_upload/models/column_info_model.dart';

class CsvUploadResModel extends Equatable {
  const CsvUploadResModel({
    required this.message,
    required this.datasetId,
    required this.columnInfo,
    required this.sampleData,
  });

  final String message;
  final String datasetId;
  final List<ColumnInfoModel> columnInfo;
  final List<Map<String, dynamic>> sampleData;

  factory CsvUploadResModel.fromJson(Map<String, dynamic> json) {
    return CsvUploadResModel(
      message: json['message'] as String,
      datasetId: json['datasetId'] as String,
      columnInfo:
          (json['columnInfo'] as List)
              .map((e) => ColumnInfoModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      sampleData:
          (json['sampleData'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList(),
    );
  }

  @override
  List<Object?> get props => [message, datasetId, columnInfo, sampleData];
}
