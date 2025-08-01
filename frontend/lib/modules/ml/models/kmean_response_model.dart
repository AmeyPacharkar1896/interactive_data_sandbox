// frontend\lib\modules\ml\models\kmean_response_model.dart

import 'package:equatable/equatable.dart';
import 'package:frontend/modules/ml/models/kmean_centroid_model.dart';
import 'package:frontend/modules/ml/models/kmean_plot_point_model.dart';

class KMeansResponseModel extends Equatable {
  final List<KMeansPlotPointModel> plotData;
  final List<KMeansCentroidModel> centroids;
  final double inertia;

  const KMeansResponseModel({
    required this.plotData,
    required this.centroids,
    required this.inertia,
  });

  factory KMeansResponseModel.fromJson(Map<String, dynamic> json) {
    return KMeansResponseModel(
      plotData:
          (json['plot_data'] as List<dynamic>?)
              ?.where((e) => e is Map<String, dynamic>)
              .map(
                (e) => KMeansPlotPointModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      centroids:
          (json['centroids'] as List<dynamic>?)
              ?.where((e) => e is Map<String, dynamic>)
              .map(
                (e) => KMeansCentroidModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      inertia: (json['inertia'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [plotData, centroids, inertia];
}
