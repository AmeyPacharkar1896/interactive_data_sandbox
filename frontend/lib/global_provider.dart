import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/data_upload/bloc/data_upload_bloc.dart';
import 'package:frontend/modules/eda/bloc/eda_bloc.dart';
import 'package:frontend/modules/ml/bloc/ml_bloc.dart';

class GlobalProvider extends StatelessWidget {
  final Widget child;
  const GlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DataUploadBloc>(create: (context) => DataUploadBloc()),
        BlocProvider<EdaBloc>(create: (context) => EdaBloc()),
        BlocProvider(create: (context) => MlBloc()),
      ],
      child: child,
    );
  }
}
