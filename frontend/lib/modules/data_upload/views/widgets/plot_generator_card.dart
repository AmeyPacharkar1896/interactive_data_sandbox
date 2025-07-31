// frontend/lib/modules/data_upload/widgets/plot_generator_card.dart

import 'package:flutter/material.dart';
import 'package:frontend/modules/data_upload/models/column_info_model.dart';

class PlotGeneratorCard extends StatelessWidget {
  final List<ColumnInfoModel> columnInfo;
  final String? currentDatasetId;

  const PlotGeneratorCard({
    super.key,
    required this.columnInfo,
    this.currentDatasetId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Shrink wrap content
          children: [
            const Text(
              'Create a Visualization:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            // Placeholder for X-Axis Dropdown
            Text('X-Axis Feature: (Dropdown goes here)'),
            const SizedBox(height: 10),
            // Placeholder for Y-Axis Dropdown
            Text('Y-Axis Feature: (Dropdown goes here)'),
            const SizedBox(height: 20),
            // Placeholder for Generate Plot Button
            ElevatedButton(
              onPressed: null, // Disabled for now
              child: const Text('Generate Plot'),
            ),
            // DEBUG: Display column info passed
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: columnInfo.length,
            //   itemBuilder: (context, index) {
            //     return Text(columnInfo[index].name + ' - ' + columnInfo[index].dtype);
            //   },
            // ),
            // Text('Dataset ID: ${currentDatasetId ?? 'N/A'}')
          ],
        ),
      ),
    );
  }
}
