// frontend\lib\modules\ml\models\kmean_plot_point_model.dart
import 'package:frontend/modules/eda/models/scatterplot_point_model.dart';

class KMeansPlotPointModel extends ScatterPlotPointModel {
  final int clusterId;

  const KMeansPlotPointModel({
    required super.x,
    required super.y,
    required this.clusterId,
  });

  factory KMeansPlotPointModel.fromJson(Map<String, dynamic> json) {
    return KMeansPlotPointModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      clusterId: json['cluster_id'] as int,
    );
  }

  @override
  List<Object?> get props => [x, y, clusterId];
}
