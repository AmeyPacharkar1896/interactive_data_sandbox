// frontend/lib/modules/data_upload/widgets/status_message_display.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';
import 'dart:developer'; 

class StatusMessageDisplay extends StatelessWidget {
  const StatusMessageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataUploadBloc, DataUploadState>(
      builder: (context, state) {
        // --- DEBUG PRINT ---
        log('STATUS DISPLAY: Received state: ${state.runtimeType}');
        if (state is DataUploadStateError) {
          log('STATUS DISPLAY: Error message content: ${state.error}');
        }
        // --- END DEBUG PRINT ---

        if (state is DataUploadStateLoading) {
          return Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Status: ${state.message}'),
              ),
            ],
          );
        } else if (state is DataUploadStateLoaded) {
          return const Text('Status: CSV data loaded and ready!');
        } else if (state is DataUploadStateError) {
          String displayError = state.error ?? 'An unexpected error occurred.';
          if (displayError.contains(':')) {
            displayError = displayError.split(':').last.trim();
          }
          return Text(
            'Status: $displayError',
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return const Text('Status: Ready to upload CSV.');
        }
      },
    );
  }
}