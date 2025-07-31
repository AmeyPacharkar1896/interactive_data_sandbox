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

import 'package:frontend/modules/eda/bloc/eda_bloc.dart';

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
            // --- CRITICAL FIX: Dispatch EdaEventFetchNumericalColumns ---
            context.read<EdaBloc>().add(
              EdaEventFetchNumericalColumns(
                datasetId: state.uploadResponse.datasetId,
              ),
            );
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
          String? currentDatasetId;
          if (state is DataUploadStateLoaded) {
            currentDatasetId = state.uploadResponse.datasetId;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: PlotGeneratorCard(
                          currentDatasetId: currentDatasetId,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child:
                              PlotDisplayCard(), // PlotDisplayCard doesn't need data passed here yet
                        ),
                        if (state is DataUploadStateLoaded) ...[
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 1,
                            child: Card(
                              child: Column(
                                children: [
                                  TabBar(
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
                                      children: [
                                        ColumnInfoDisplay(
                                          columnInfo:
                                              state.uploadResponse.columnInfo,
                                        ),
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
                        ] else
                          const Expanded(
                            flex: 1,
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Upload a CSV file on the left to begin your data exploration!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
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
