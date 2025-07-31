// frontend/lib/modules/data_upload/widgets/sample_data_table.dart

import 'package:flutter/material.dart';

class SampleDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> sampleData;

  const SampleDataTable({Key? key, required this.sampleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sampleData.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> headers =
        sampleData.isNotEmpty
            ? sampleData[0].keys.map((key) => key.toString()).toList()
            : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sample Data (First 5 Rows):',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        // --- CRITICAL FIX: Removed the Expanded wrapping SingleChildScrollView here ---
        SingleChildScrollView(
          // For horizontal scrolling
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Colors.grey),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                children:
                    headers
                        .map(
                          (header) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              header,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              ...sampleData
                  .map(
                    (row) => TableRow(
                      children:
                          headers.map((header) {
                            final dynamic value = row[header];
                            final String displayValue = value?.toString() ?? '';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(displayValue),
                            );
                          }).toList(),
                    ),
                  )
                  ,
            ],
          ),
        ),
      ],
    );
  }
}
