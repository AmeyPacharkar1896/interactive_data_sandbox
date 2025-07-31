// frontend/lib/modules/data_upload/widgets/sample_data_table.dart

import 'package:flutter/material.dart';

class SampleDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> sampleData;

  const SampleDataTable({super.key, required this.sampleData});

  @override
  Widget build(BuildContext context) {
    if (sampleData.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> headers = sampleData.isNotEmpty
        ? sampleData[0].keys.map((key) => key.toString()).toList()
        : [];

    return Card( // Wrap in a Card for the "Containerization" look
      elevation: 0,
      shape: Theme.of(context).cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sample Data (First 5 Rows):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Larger, bolder title
            ),
            const SizedBox(height: 15),
            Expanded( // Ensures the table itself takes remaining vertical space
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Only horizontal scrolling for the table cells
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300, width: 1.0), // Lighter border
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    // Header row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade100), // Light gray header background
                      children: headers.map((header) => Padding(
                        padding: const EdgeInsets.all(10.0), // Increased padding
                        child: Text(
                          header,
                          style: const TextStyle(fontWeight: FontWeight.bold), // Bold header text
                          textAlign: TextAlign.center, // Center align header
                        ),
                      )).toList(),
                    ),
                    // Data rows (Zebra-striping)
                    ...sampleData.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> row = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.white : Colors.grey.shade50, // Alternating row colors
                        ),
                        children: headers.map((header) {
                          final dynamic value = row[header];
                          final String displayValue = value?.toString() ?? '';
                          return Padding(
                            padding: const EdgeInsets.all(10.0), // Increased padding
                            child: Text(displayValue),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}