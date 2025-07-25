// frontend\lib\modules\data_upload\models\csv_upload_req_model.dart

import 'package:equatable/equatable.dart';

class CsvUploadReqModel extends Equatable {
  const CsvUploadReqModel({required this.csvData});

  final String csvData;

  Map<String, dynamic> toJson() {
    return {'csvData': csvData};
  }

  @override
  List<Object?> get props => [csvData];
}
