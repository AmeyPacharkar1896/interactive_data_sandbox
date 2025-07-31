// frontend\lib\application.dart

import 'package:flutter/material.dart';
import 'package:frontend/modules/data_upload/views/data_upload_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Interactive Data Science Sandbox",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const DataUploadPage(),
    );
  }
}
