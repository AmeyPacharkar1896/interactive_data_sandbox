// frontend\lib\modules\eda\models\scatterplot_response_model.dart
import 'package:equatable/equatable.dart';
import 'package:frontend/modules/eda/models/scatterplot_point_model.dart';

class ScatterPlotResponseModel extends Equatable {
  final List<ScatterPlotPointModel> plotData;

  const ScatterPlotResponseModel({required this.plotData});

  factory ScatterPlotResponseModel.fromJson(Map<String, dynamic> json) {
    return ScatterPlotResponseModel(
      plotData:
          (json['plot_data'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ScatterPlotPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [plotData];
}
