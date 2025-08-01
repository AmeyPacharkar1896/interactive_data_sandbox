// frontend\lib\modules\ml\models\kmean_request_model.dart
import 'package:equatable/equatable.dart';

class KMeansRequestModel extends Equatable {
  final String datasetId;
  final String featureX;
  final String featureY;
  final int nClusters;

  const KMeansRequestModel({
    required this.datasetId,
    required this.featureX,
    required this.featureY,
    required this.nClusters,
  });

  Map<String, dynamic> toJson() {
    return {
      'dataset_id': datasetId,
      'feature_x': featureX,
      'feature_y': featureY,
      'n_clusters': nClusters,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [datasetId, featureX, featureY, nClusters];
}
