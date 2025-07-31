// frontend\lib\modules\eda\models\numerical_column_response_model.dart

import 'package:equatable/equatable.dart';

class NumericalColumnResponseModel extends Equatable {
  final List<String> numericalColumns;

  const NumericalColumnResponseModel({required this.numericalColumns});

  factory NumericalColumnResponseModel.fromJson(Map<String, dynamic> json) {
    // --- CRITICAL FIX: Explicit and robust parsing for the list of strings ---
    final dynamic rawList = json['numerical_columns'];
    final List<String> parsedColumns = [];

    if (rawList is List) {
      // Check if the raw data is actually a List
      for (final item in rawList) {
        if (item != null) {
          // Ensure individual item is not null
          parsedColumns.add(item.toString()); // Convert to String and add
        }
      }
    }
    // If rawList is null or not a List, parsedColumns will remain empty, which is the correct fallback.

    return NumericalColumnResponseModel(numericalColumns: parsedColumns);
  }

  @override
  List<Object?> get props => [numericalColumns];
}

// ... rest of the models ...
