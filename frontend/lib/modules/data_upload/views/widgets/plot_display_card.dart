// frontend/lib/modules/data_upload/widgets/plot_display_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/modules/eda/bloc/eda_bloc.dart';
import 'dart:math'; // For min/max calculations

class PlotDisplayCard extends StatelessWidget {
  const PlotDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EdaBloc, EdaState>(
          builder: (context, edaState) {
            Widget content;
            String title = 'Scatter Plot Area';

            if (edaState is EdaStateLoading) {
              content = const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Loading data..."),
                ],
              );
            } else if (edaState is EdaStateScatterPlotLoaded) {
              title = '${edaState.featureY} vs. ${edaState.featureX}';

              final List<ScatterSpot> spots = edaState.plotResponse.plotData.map((point) {
                return ScatterSpot(point.x, point.y);
              }).toList();

              // --- NEW: Calculate min/max for axis bounds and add padding ---
              double minX = spots.isNotEmpty ? spots.map((s) => s.x).reduce(min) : 0;
              double maxX = spots.isNotEmpty ? spots.map((s) => s.x).reduce(max) : 1;
              double minY = spots.isNotEmpty ? spots.map((s) => s.y).reduce(min) : 0;
              double maxY = spots.isNotEmpty ? spots.map((s) => s.y).reduce(max) : 1;

              // Add a small margin to the min/max values for better visualization
              final double xPadding = (maxX - minX) * 0.05; // 5% padding
              final double yPadding = (maxY - minY) * 0.05;
              
              minX = minX - xPadding;
              maxX = maxX + xPadding;
              minY = minY - yPadding;
              maxY = maxY + yPadding;

              content = Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScatterChart(
                        ScatterChartData(
                          scatterSpots: spots,
                          minX: minX, // Apply calculated minX
                          maxX: maxX, // Apply calculated maxX
                          minY: minY, // Apply calculated minY
                          maxY: maxY, // Apply calculated maxY
                          scatterTouchData: ScatterTouchData(
                            enabled: true,
                            touchTooltipData: ScatterTouchTooltipData(
                              getTooltipItems: (ScatterSpot touchedSpot) {
                                return ScatterTooltipItem(
                                  'X: ${touchedSpot.x.toStringAsFixed(2)}\nY: ${touchedSpot.y.toStringAsFixed(2)}',
                                  textStyle: const TextStyle(color: Colors.white),
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
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return Text(
                                    value.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                              axisNameWidget: Text(
                                edaState.featureX,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              axisNameSize: 20,
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return Text(
                                    value.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                              axisNameWidget: Text(
                                edaState.featureY,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              axisNameSize: 20,
                            ),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          gridData: const FlGridData(show: false),
                          // You can also use default size: 8
                          // spotRadius: 5.0, // Fixed radius for all spots
                        ),
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Total points: ${edaState.plotResponse.plotData.length}'),
                ],
              );
            } else if (edaState is EdaStateError) {
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('Error generating plot: ${edaState.error ?? "Unknown error"}'),
                ],
              );
            } else {
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.scatter_plot, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text('Select features on the left to see a plot here.'),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Center(child: content),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}