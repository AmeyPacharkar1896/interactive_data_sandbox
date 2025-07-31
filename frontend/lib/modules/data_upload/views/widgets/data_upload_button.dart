// frontend/lib/modules/data_upload/widgets/data_upload_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';

class DataUploadButton extends StatelessWidget {
  const DataUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // Use ElevatedButton.icon for text and icon
      onPressed: () {
        context.read<DataUploadBloc>().add(
          const DataUploadEventPickAndUploadCsvFile(),
        );
      },
      icon: const Icon(Icons.upload_file, color: Colors.white), // Upload icon
      label: const Text(
        'Upload CSV File',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ), // White text, larger font
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Theme.of(
              context,
            ).primaryColor, // Use theme's primary color (vibrant blue)
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ), // Larger padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        minimumSize: const Size(180, 50), // Ensure a minimum size
      ),
    );
  }
}
