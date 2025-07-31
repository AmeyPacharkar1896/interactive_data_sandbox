// frontend\lib\modules\data_upload\views\widgets\column_info_display.dart

import 'package:flutter/material.dart';
import 'package:frontend/modules/data_upload/models/column_info_model.dart';

class ColumnInfoDisplay extends StatelessWidget {
  final List<ColumnInfoModel> columnInfo;
  const ColumnInfoDisplay({super.key, required this.columnInfo});

  @override
  Widget build(BuildContext context) {
    if (columnInfo.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Column Information:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...columnInfo
            .map((col) => Text('- ${col.name} (Type: ${col.dtype})'))
            .toList(),
      ],
    );
  }
}
