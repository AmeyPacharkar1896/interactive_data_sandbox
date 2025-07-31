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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Main Column: arranges top elements (button, status) and then the content panels
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Button and Status Display
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween, // Space out upload button and status
                  children: [
                    const DataUploadButton(),
                    const SizedBox(width: 20), // Spacer
                    // Status bar might take variable width, so wrap it
                    Expanded(child: const StatusMessageDisplay()),
                  ],
                ),
                const SizedBox(height: 20),

                // Conditional display of data panels if data is loaded
                if (state is DataUploadStateLoaded)
                  Expanded(
                    // This Expanded ensures the Row takes all remaining vertical space
                    child: Row(
                      // This Row divides the screen horizontally into two panels
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch, // Ensure panels stretch to fill height
                      children: [
                        // Left Panel: File Info, Dataset ID, Column Information
                        Expanded(
                          flex: 1, // Allocate 1 part of the horizontal space
                          child: Column(
                            // Column inside the left panel
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // File path and Dataset ID
                              Text(
                                'Selected File: ${state.fileName}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Dataset ID: ${state.uploadResponse.datasetId}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ), // Smaller ID text
                              const SizedBox(height: 20),

                              // Column Information Display (now a Card with internal scrolling)
                              Expanded(
                                // Expanded ensures ColumnInfoDisplay takes remaining vertical space
                                child: ColumnInfoDisplay(
                                  columnInfo: state.uploadResponse.columnInfo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ), // Spacer between the two panels
                        // Right Panel: Sample Data Table
                        Expanded(
                          flex: 2, // Allocate 2 parts of the horizontal space
                          child: SampleDataTable(
                            // SampleDataTable is now a Card with internal scrolling
                            sampleData: state.uploadResponse.sampleData,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  // Optional: Display a placeholder message when no data is loaded yet
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Upload a CSV file to begin your data exploration!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
