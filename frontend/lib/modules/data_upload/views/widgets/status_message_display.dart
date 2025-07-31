// frontend/lib/modules/data_upload/widgets/status_message_display.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';

import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';

class StatusMessageDisplay extends StatelessWidget {
  const StatusMessageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataUploadBloc, DataUploadState>(
      builder: (context, state) {
        log('STATUS DISPLAY: Received state: ${state.runtimeType}');
        if (state is DataUploadStateError) {
          log('STATUS DISPLAY: Error message content: ${state.error}');
        }

        Color backgroundColor = Colors.grey.shade300; // Default light gray
        Color textColor = Colors.black87;
        String message = 'Ready to upload CSV.';
        Widget? leadingIcon;

        if (state is DataUploadStateLoading) {
          backgroundColor = Colors.blue.shade100;
          textColor = Colors.blue.shade800;
          message = state.message;
          leadingIcon = const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue,
            ),
          );
        } else if (state is DataUploadStateLoaded) {
          backgroundColor = Colors.green.shade100;
          textColor = Colors.green.shade800;
          message = 'CSV loaded and ready!';
          leadingIcon = const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          );
        } else if (state is DataUploadStateError) {
          backgroundColor = Colors.red.shade100;
          textColor = Colors.red.shade800;
          String displayError = state.error ?? 'An unexpected error occurred.';
          if (displayError.contains(':')) {
            displayError = displayError.split(':').last.trim();
          }
          message = 'Error: $displayError';
          leadingIcon = const Icon(Icons.error_outline, color: Colors.red);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Wrap content horizontally
            children: [
              if (leadingIcon != null) ...[
                leadingIcon,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
