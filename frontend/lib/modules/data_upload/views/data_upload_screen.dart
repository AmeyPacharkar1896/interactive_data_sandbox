// frontend/lib/modules/data_upload/view/data_upload_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';
import 'package:frontend/modules/data_upload/views/widgets/column_info_display.dart';
import 'package:frontend/modules/data_upload/views/widgets/data_upload_button.dart';
import 'package:frontend/modules/data_upload/views/widgets/plot_display_card.dart';
import 'package:frontend/modules/data_upload/views/widgets/plot_generator_card.dart';
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
            child: Row(
              // Main Row for the two-column layout
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Left Column: Control Panel (Fixed Width) ---
                SizedBox(
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card 1: Dataset Information
                      Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const DataUploadButton(),
                              const SizedBox(height: 15),
                              const StatusMessageDisplay(),
                              const SizedBox(height: 15),
                              // File Info & Dataset ID (now only visible if data is loaded)
                              if (state is DataUploadStateLoaded) ...[
                                Text(
                                  'Selected File: ${state.fileName}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Dataset ID: ${state.uploadResponse.datasetId}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                              // If no data loaded, show initial status for DataUploadButton and StatusMessageDisplay
                              if (state is! DataUploadStateLoaded) ...[
                                // You can add a placeholder message here if needed for initial empty state,
                                // but StatusMessageDisplay already handles "Ready to upload"
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Card 2: Plot Generator (Placeholder for now)
                      Expanded(
                        // This card expands to fill remaining vertical space in the left column
                        child: PlotGeneratorCard(
                          // This will be created in the next steps
                          // We'll pass necessary data like numerical column names here
                          columnInfo:
                              state is DataUploadStateLoaded
                                  ? state.uploadResponse.columnInfo
                                  : [],
                          currentDatasetId:
                              state is DataUploadStateLoaded
                                  ? state.uploadResponse.datasetId
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),
                // --- Right Column: Display Area (Flexible Width) ---
                Expanded(
                  child: DefaultTabController(
                    // For Tabbed View
                    length: 2, // For Column Info and Sample Data tabs
                    child: Column(
                      children: [
                        // Plot Display Card (Placeholder for now, conditional display)
                        if (state is DataUploadStateLoaded)
                          Expanded(
                            // Plot display takes major part of vertical space
                            flex: 2, // Allocate more space for the plot
                            child: PlotDisplayCard(
                              // This will be created in the next steps
                              // Plot data will be passed here later
                            ),
                          )
                        else
                          // Placeholder when no data loaded, fills the right side
                          Expanded(
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Upload a CSV file on the left to begin your data exploration!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                        if (state is DataUploadStateLoaded) ...[
                          const SizedBox(height: 16),
                          Expanded(
                            flex:
                                1, // Allocate less space for tabs compared to plot
                            child: Card(
                              child: Column(
                                children: [
                                  TabBar(
                                    // Tabs for Column Info and Sample Data
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor: Colors.grey,
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    tabs: const [
                                      Tab(text: 'Column Info'),
                                      Tab(text: 'Raw Data'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      // Content for the tabs
                                      children: [
                                        // Column Info Tab Content
                                        ColumnInfoDisplay(
                                          columnInfo:
                                              state.uploadResponse.columnInfo,
                                        ),
                                        // Sample Data Tab Content
                                        SampleDataTable(
                                          sampleData:
                                              state.uploadResponse.sampleData,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
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
