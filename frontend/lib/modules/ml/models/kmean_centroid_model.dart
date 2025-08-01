// frontend\lib\modules\ml\models\kmean_centroid_model.dart
import 'package:frontend/modules/eda/models/scatterplot_point_model.dart';

class KMeansCentroidModel extends ScatterPlotPointModel {
  final int clusterId;

  const KMeansCentroidModel({
    required super.x,
    required super.y,
    required this.clusterId,
  });

  factory KMeansCentroidModel.fromJson(Map<String, dynamic> json) {
    return KMeansCentroidModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      clusterId: json['cluster_id'] as int,
    );
  }

  @override
  List<Object?> get props => [x, y, clusterId];
}
