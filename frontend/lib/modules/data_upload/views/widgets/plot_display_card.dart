// frontend/lib/modules/data_upload/widgets/plot_display_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/eda/bloc/eda_bloc.dart';

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

            // --- CRITICAL FIX: Corrected BLoC State names ---
            if (edaState is EdaStateLoading) {
              // CORRECTED STATE NAME
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(edaState.message),
                ],
              );
            } else if (edaState is EdaStateScatterPlotLoaded) {
              // CORRECTED STATE NAME
              title = '${edaState.featureY} vs. ${edaState.featureX}';
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.show_chart, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('Plot for $title will be displayed here.'),
                  Text(
                    'Total points: ${edaState.plotResponse.plotData.length}',
                  ),
                ],
              );
            } else if (edaState is EdaStateError) {
              // CORRECTED STATE NAME
              content = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    'Error generating plot: ${edaState.error ?? "Unknown error"}',
                  ),
                ],
              );
            } else {
              // EdaStateInitial or EdaStateNumericalColumnsLoaded
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
        ),
      ),
    );
  }
}
