// frontend\lib\modules\eda\models\scatterplot_point_model.dart
import 'package:equatable/equatable.dart';

class ScatterPlotPointModel extends Equatable {
  final double x;
  final double y;

  const ScatterPlotPointModel({required this.x, required this.y});

  factory ScatterPlotPointModel.fromJson(Map<String, dynamic> json) {
    return ScatterPlotPointModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [x, y];
}
