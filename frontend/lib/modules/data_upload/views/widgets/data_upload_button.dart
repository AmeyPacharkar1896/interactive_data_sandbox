// frontend\lib\modules\data_upload\views\widgets\data_upload_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';

class DataUploadButton extends StatelessWidget {
  const DataUploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<DataUploadBloc>().add(
          const DataUploadEventPickAndUploadCsvFile(),
        );
      },
      child: const Text('Upload CSV File'),
    );
  }
}
