// frontend/lib/application.dart

import 'package:flutter/material.dart';
import 'package:frontend/global_provider.dart';
import 'package:frontend/modules/data_upload/views/data_upload_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      child: MaterialApp(
        title: "Interactive Data Science Sandbox",
        theme: ThemeData(
          primarySwatch: Colors.blue, // Primary color for buttons etc.
          scaffoldBackgroundColor: const Color(
            0xFFF3F4F6,
          ), // Light gray background
          cardTheme: CardTheme(
            // Global card styling
            elevation: 2, // Subtle shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            margin:
                EdgeInsets
                    .zero, // Cards will handle their own margins via padding
          ),
          appBarTheme: const AppBarTheme(
            // Minimal app bar
            backgroundColor: Color(0xFFF3F4F6), // Match background
            elevation: 0, // No shadow
            foregroundColor: Colors.black87, // Dark text color
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ), // Header font
          ),
          // Define default text styles if you use a specific font later (e.g., 'Inter' or 'Poppins')
          // textTheme: const TextTheme(
          //   bodyLarge: TextStyle(fontFamily: 'Inter'),
          //   bodyMedium: TextStyle(fontFamily: 'Inter'),
          //   // etc.
          // ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner:
            false, // <-- Add this line to remove the debug banner
        home: const DataUploadScreen(),
      ),
    );
  }
}
