// frontend/lib/modules/data_upload/widgets/plot_generator_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/modules/eda/bloc/eda_bloc.dart';
import 'dart:developer'; // Import for log

class PlotGeneratorCard extends StatefulWidget {
  final String? currentDatasetId;

  const PlotGeneratorCard({super.key, this.currentDatasetId});

  @override
  State<PlotGeneratorCard> createState() => _PlotGeneratorCardState();
}

class _PlotGeneratorCardState extends State<PlotGeneratorCard> {
  String? _selectedXFeature;
  String? _selectedYFeature;
  List<String> _numericalColumns = [];

  @override
  void didUpdateWidget(covariant PlotGeneratorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentDatasetId != oldWidget.currentDatasetId) {
      log('PLOT GENERATOR CARD: Dataset ID changed. Resetting selections.');
      setState(() {
        _selectedXFeature = null;
        _selectedYFeature = null;
        _numericalColumns = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(
      'PLOT GENERATOR CARD: Building with currentDatasetId: ${widget.currentDatasetId}',
    );
    log(
      'PLOT GENERATOR CARD: _numericalColumns current state: $_numericalColumns (count: ${_numericalColumns.length})',
    );
    log(
      'PLOT GENERATOR CARD: Dropdowns enabled: ${widget.currentDatasetId != null && _numericalColumns.isNotEmpty}',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a Visualization:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            BlocListener<EdaBloc, EdaState>(
              listener: (context, edaState) {
                log(
                  'PLOT GENERATOR CARD LISTENER: Received EDA State: ${edaState.runtimeType}',
                );
                if (edaState is EdaStateNumericalColumnsLoaded) {
                  log(
                    'PLOT GENERATOR CARD LISTENER: EdaStateNumericalColumnsLoaded received. Columns: ${edaState.numericalColumns}',
                  );
                  setState(() {
                    _numericalColumns = edaState.numericalColumns;
                    if (_selectedXFeature != null &&
                        !_numericalColumns.contains(_selectedXFeature)) {
                      _selectedXFeature = null;
                    }
                    if (_selectedYFeature != null &&
                        !_numericalColumns.contains(_selectedYFeature)) {
                      _selectedYFeature = null;
                    }
                  });
                  log(
                    'PLOT GENERATOR CARD LISTENER: _numericalColumns updated to: $_numericalColumns',
                  );
                } else if (edaState is EdaStateError) {
                  log(
                    'PLOT GENERATOR CARD LISTENER: EdaError received. Error: ${edaState.error}',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('EDA Error: ${edaState.error}')),
                  );
                }
              },
              child: const SizedBox.shrink(),
            ),

            _buildFeatureDropdown(
              label: 'X-Axis Feature (Numerical Only)',
              selectedValue: _selectedXFeature,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedXFeature = newValue;
                });
              },
              columns: _numericalColumns,
              enabled:
                  widget.currentDatasetId != null &&
                  _numericalColumns.isNotEmpty,
            ),
            const SizedBox(height: 15),

            _buildFeatureDropdown(
              label: 'Y-Axis Feature (Numerical Only)',
              selectedValue: _selectedYFeature,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedYFeature = newValue;
                });
              },
              columns: _numericalColumns,
              enabled:
                  widget.currentDatasetId != null &&
                  _numericalColumns.isNotEmpty,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_selectedXFeature != null &&
                            _selectedYFeature != null &&
                            _selectedXFeature != _selectedYFeature &&
                            widget.currentDatasetId != null)
                        ? () {
                          context.read<EdaBloc>().add(
                            EdaEventGenerateScatterPlot(
                              datasetId: widget.currentDatasetId!,
                              featureX: _selectedXFeature!,
                              featureY: _selectedYFeature!,
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Generate Plot',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureDropdown({
    required String label,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    required List<String> columns,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            color: enabled ? Colors.white : Colors.grey.shade200,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(
                'Select a column...',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              onChanged: enabled ? onChanged : null,
              items:
                  columns.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
              ),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
