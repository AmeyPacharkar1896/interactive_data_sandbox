// frontend/lib/modules/data_upload/widgets/plot_display_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/modules/eda/bloc/eda_bloc.dart';
import 'package:frontend/modules/ml/bloc/ml_bloc.dart';
import 'dart:math';

class PlotDisplayCard extends StatelessWidget {
  const PlotDisplayCard({super.key});

  static const List<Color> _clusterColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.brown,
    Colors.pinkAccent,
    Colors.indigo,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MlBloc, MLState>(
          // Use correct MlState type here
          builder: (mlContext, mlState) {
            return BlocBuilder<EdaBloc, EdaState>(
              builder: (edaContext, edaState) {
                // --- CRITICAL FIX 1: Initialize 'content' to a default Widget ---
                Widget content = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.scatter_plot,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select features on the left to see a plot here.',
                    ),
                  ],
                );
                String title = 'Scatter Plot Area';

                List<ScatterSpot> scatterSpots = [];
                List<ScatterSpot> centroidSpots = [];
                bool showCentroids = false;

                double minX = 0, maxX = 1, minY = 0, maxY = 1;
                String featureX = '';
                String featureY = '';

                // --- Determine current plot data and state ---
                if (mlState is MLStateLoading) {
                  // Corrected from MLStateLoading
                  content = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(mlState.message),
                    ],
                  );
                } else if (mlState is MlStateKMeansLoaded) {
                  // Corrected from MlStateKMeansLoaded
                  title =
                      'K-Means: ${mlState.featureY} vs. ${mlState.featureX} (k=${mlState.kmeansResponse.centroids.length})';
                  featureX = mlState.featureX;
                  featureY = mlState.featureY;
                  showCentroids = true;

                  scatterSpots =
                      mlState.kmeansResponse.plotData.map((point) {
                        final Color spotColor =
                            _clusterColors[point.clusterId %
                                _clusterColors.length];
                        return ScatterSpot(
                          point.x,
                          point.y,
                          dotPainter: FlDotCirclePainter(
                            radius: 5,
                            color: spotColor.withOpacity(0.8),
                            strokeWidth: 0,
                          ),
                        );
                      }).toList();

                  centroidSpots =
                      mlState.kmeansResponse.centroids.map((centroid) {
                        final Color centroidColor =
                            _clusterColors[centroid.clusterId %
                                _clusterColors.length];
                        return ScatterSpot(
                          centroid.x,
                          centroid.y,
                          dotPainter: FlDotSquarePainter(
                            size: 12,
                            color: centroidColor,
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                          ),
                        );
                      }).toList();
                } else if (mlState is MlStateError) {
                  // Corrected from MlStateError
                  content = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text('ML Error: ${mlState.error ?? "Unknown error"}'),
                    ],
                  );
                }
                // Fallback to EDA plot if ML state is not active/error
                else if (edaState is EdaStateLoading) {
                  content = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(edaState.message),
                    ],
                  );
                } else if (edaState is EdaStateScatterPlotLoaded) {
                  title = '${edaState.featureY} vs. ${edaState.featureX}';
                  featureX =
                      edaState
                          .featureX; // Ensure featureX/Y are set for EDA plots
                  featureY = edaState.featureY;

                  scatterSpots =
                      edaState.plotResponse.plotData.map((point) {
                        return ScatterSpot(
                          point.x,
                          point.y,
                          dotPainter: FlDotCirclePainter(
                            radius: 5,
                            color: Colors.blue.withOpacity(0.6),
                            strokeWidth: 0,
                          ),
                        );
                      }).toList();
                } else if (edaState is EdaStateError) {
                  content = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 10),
                      Text('EDA Error: ${edaState.error ?? "Unknown error"}'),
                    ],
                  );
                }

                // --- Common Plot Rendering Logic (only if scatterSpots has data from any state) ---
                // This section now relies on the `scatterSpots` and `centroidSpots` populated
                // by the state-specific blocks above.
                if (scatterSpots.isNotEmpty || centroidSpots.isNotEmpty) {
                  List<ScatterSpot> allPointsForBounds = [
                    ...scatterSpots,
                    ...centroidSpots,
                  ];
                  if (allPointsForBounds.isEmpty) {
                    minX = 0;
                    maxX = 1;
                    minY = 0;
                    maxY = 1;
                  } else {
                    minX = allPointsForBounds.map((s) => s.x).reduce(min);
                    maxX = allPointsForBounds.map((s) => s.x).reduce(max);
                    minY = allPointsForBounds.map((s) => s.y).reduce(min);
                    maxY = allPointsForBounds
                        .map((s) => s.y)
                        .reduce(max); // Corrected typo here

                    final double xPadding = (maxX - minX).abs() * 0.05;
                    final double yPadding = (maxY - minY).abs() * 0.05;
                    minX = minX - xPadding;
                    maxX = maxX + xPadding;
                    minY = minY - yPadding;
                    maxY = maxY + yPadding;
                  }

                  List<ScatterSpot> finalSpotsToRender = [
                    ...scatterSpots,
                    ...centroidSpots,
                  ];

                  content = Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ScatterChart(
                            ScatterChartData(
                              scatterSpots: finalSpotsToRender,
                              minX: minX,
                              maxX: maxX,
                              minY: minY,
                              maxY: maxY,
                              scatterTouchData: ScatterTouchData(
                                enabled: true,
                                touchTooltipData: ScatterTouchTooltipData(
                                  getTooltipItems: (ScatterSpot touchedSpot) {
                                    return ScatterTooltipItem(
                                      'X: ${touchedSpot.x.toStringAsFixed(2)}\nY: ${touchedSpot.y.toStringAsFixed(2)}',
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget:
                                        (value, meta) => Text(
                                          value.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                  ),
                                  axisNameWidget: Text(
                                    featureX,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  axisNameSize: 20,
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget:
                                        (value, meta) => Text(
                                          value.toStringAsFixed(1),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                  ),
                                  axisNameWidget: Text(
                                    featureY,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  axisNameSize: 20,
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              gridData: const FlGridData(show: false),
                            ),
                            duration: const Duration(
                              milliseconds: 150,
                            ), // Using 'duration' instead of 'swapAnimationDuration' in 1.0.0
                            curve:
                                Curves
                                    .linear, // Using 'curve' instead of 'swapAnimationCurve' in 1.0.0
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Total points: ${finalSpotsToRender.length}'),
                      if (showCentroids &&
                          mlState is MlStateKMeansLoaded &&
                          mlState.kmeansResponse.silhouetteScore != null)
                        Text(
                          'Silhouette Score: ${mlState.kmeansResponse.silhouetteScore!.toStringAsFixed(3)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      if (showCentroids)
                        Text(
                          'Inertia: ${mlState is MlStateKMeansLoaded ? mlState.kmeansResponse.inertia.toStringAsFixed(2) : 'N/A'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  );
                }
                // No 'else' needed here, 'content' is already initialized.

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(child: Center(child: content)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
