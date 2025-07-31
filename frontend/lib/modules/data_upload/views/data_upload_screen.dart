// frontend/lib/modules/data_upload/view/data_upload_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';
import 'package:frontend/modules/data_upload/views/widgets/column_info_display.dart';
import 'package:frontend/modules/data_upload/views/widgets/data_upload_button.dart';
import 'package:frontend/modules/data_upload/views/widgets/sample_data_table.dart';
import 'package:frontend/modules/data_upload/views/widgets/status_message_display.dart';
import 'package:frontend/shared/show_snackbar.dart';

class DataUploadScreen extends StatelessWidget {
  const DataUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Data Science Sandbox')),
      body: BlocConsumer<DataUploadBloc, DataUploadState>(
        listener: (context, state) {
          if (state is DataUploadStateLoaded) {
            showSnackBar(context, 'CSV uploaded successfully!', isError: false);
          } else if (state is DataUploadStateError) {
            final String errorMessage =
                state.error ?? 'An unexpected error occurred during upload.';
            showSnackBar(
              context,
              'Upload failed: $errorMessage',
              isError: true,
            );
          }
        },
        builder: (context, state) {
          // --- CRITICAL FIX: Wrap the entire content in SingleChildScrollView ---
          return SingleChildScrollView(
            // Allows the entire screen content to scroll vertically if it overflows
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // This Column will now have unbounded height due to SingleChildScrollView
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize
                        .min, // Crucial for Columns inside SingleChildScrollView
                children: [
                  const DataUploadButton(),
                  const SizedBox(height: 20),
                  const StatusMessageDisplay(),
                  const SizedBox(height: 20),
                  if (state is DataUploadStateLoaded) ...[
                    Text('Selected File: ${state.fileName}'),
                    const SizedBox(height: 10),
                    Text('Dataset ID: ${state.uploadResponse.datasetId}'),
                    const SizedBox(height: 20),
                    ColumnInfoDisplay(
                      columnInfo: state.uploadResponse.columnInfo,
                    ),
                    const SizedBox(height: 20),
                    // --- CRITICAL FIX: REMOVE Expanded from here ---
                    // SampleDataTable must not be in Expanded if its parent Column is in a SingleChildScrollView.
                    // SampleDataTable will now take its natural vertical height.
                    SampleDataTable(
                      sampleData: state.uploadResponse.sampleData,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
