import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';
import 'package:frontend/modules/data_upload/views/data_upload_screen.dart';

class DataUploadPage extends StatelessWidget {
  const DataUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataUploadBloc>(
      create: (context) => DataUploadBloc(),
      child: DataUploadScreen(),
    );
  }
}
