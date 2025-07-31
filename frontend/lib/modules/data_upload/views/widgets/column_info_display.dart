// frontend/lib/modules/data_upload/widgets/column_info_display.dart

import 'package:flutter/material.dart';
import 'package:frontend/modules/data_upload/models/column_info_model.dart';

class ColumnInfoDisplay extends StatelessWidget {
  final List<ColumnInfoModel> columnInfo;

  const ColumnInfoDisplay({Key? key, required this.columnInfo}) : super(key: key);

  // Helper to get color for data type tag
  Color _getTypeColor(String dtype) {
    if (dtype.contains('int')) return Colors.blue.shade100;
    if (dtype.contains('float')) return Colors.green.shade100;
    if (dtype.contains('object')) return Colors.grey.shade300;
    if (dtype.contains('bool')) return Colors.purple.shade100;
    return Colors.orange.shade100; // Default for unknown types
  }

  // Helper to get text color for data type tag
  Color _getTypeTextColor(String dtype) {
    if (dtype.contains('int')) return Colors.blue.shade800;
    if (dtype.contains('float')) return Colors.green.shade800;
    if (dtype.contains('object')) return Colors.grey.shade800;
    if (dtype.contains('bool')) return Colors.purple.shade800;
    return Colors.orange.shade800; // Default for unknown types
  }

  @override
  Widget build(BuildContext context) {
    if (columnInfo.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card( // Wrap in a Card for the "Containerization" look
      elevation: 0, // CardTheme handles elevation, but can override here
      shape: Theme.of(context).cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min is implicitly true for Column in Card that's not Expanded
          children: [
            const Text(
              'Column Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Larger, bolder title
            ),
            const SizedBox(height: 15),
            Expanded( // Still need Expanded for the ListView.builder to scroll
              child: ListView.builder(
                itemCount: columnInfo.length,
                itemBuilder: (context, index) {
                  final col = columnInfo[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                      children: [
                        Text(
                          col.name,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Container( // The pill-shaped tag
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor(col.dtype),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            col.dtype,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getTypeTextColor(col.dtype),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}