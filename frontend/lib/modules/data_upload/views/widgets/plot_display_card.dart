import 'package:flutter/material.dart';

class PlotDisplayCard extends StatelessWidget {
  const PlotDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scatter Plot Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Select features on the left to see a plot here.'),
              // Placeholder for the FL Chart widget
              // This is where the actual plot will go later
            ],
          ),
        ),
      ),
    );
  }
}
