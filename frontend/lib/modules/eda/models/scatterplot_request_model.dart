// frontend\lib\modules\eda\models\scatterplot_request_model.dart

import 'package:equatable/equatable.dart';

class ScatterPlotRequestModel extends Equatable {
  final String datasetId;
  final String featureX;
  final String featureY;

  const ScatterPlotRequestModel({
    required this.datasetId,
    required this.featureX,
    required this.featureY,
  });

  Map<String, dynamic> toJson() {
    return {
      'dataset_id': datasetId,
      'feature_x': featureX,
      'feature_y': featureY,
    };
  }

  @override
  List<Object?> get props => [datasetId, featureX, featureY];
}
