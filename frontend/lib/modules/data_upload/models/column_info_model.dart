// frontend\lib\modules\data_upload\models\column_info_model.dart

import 'package:equatable/equatable.dart';

class ColumnInfoModel extends Equatable {
  const ColumnInfoModel({required this.name, required this.dtype});

  final String name;
  final String dtype;

  factory ColumnInfoModel.fromJson(Map<String, dynamic> json) {
    return ColumnInfoModel(
      name: json['name'] as String,
      dtype: json['dtype'] as String,
    );
  }

  @override
  List<Object?> get props => [name, dtype];
}
