import 'package:flutter/material.dart';
import 'pregnancy_history_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MenstrualHistoryPage extends StatefulWidget {
  const MenstrualHistoryPage({super.key});

  @override
  _MenstrualHistoryPageState createState() => _MenstrualHistoryPageState();
}

class _MenstrualHistoryPageState extends State<MenstrualHistoryPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _lastPeriodController = TextEditingController();
  bool _isPeriodNormal = true;
  bool _arePeriodsRegular = true;
  final TextEditingController _periodGapController = TextEditingController();
  bool _hasCramps = false;
  String _crampSeverity = 'Mild';
  final TextEditingController _crampMedicationController = TextEditingController();
  bool _spotting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual History'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              '1. Age at first period (yrs)?',
              _buildTextField(_ageController, 'Enter your age'),
            ),
            _buildCard(
              '2. First day of your last period?',
              _buildTextField(_lastPeriodController, 'Enter date (e.g., DD/MM/YYYY)'),
            ),
            _buildCard(
              '3. Is your period normal or abnormal?',
              _buildCheckboxRow(
                options: ['Normal', 'Abnormal'],
                values: [_isPeriodNormal, !_isPeriodNormal],
                onChanged: (index, value) {
                  setState(() {
                    _isPeriodNormal = index == 0;
                  });
                },
              ),
            ),
            _buildCard(
              '4. Are your periods regular?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                values: [_arePeriodsRegular, !_arePeriodsRegular],
                onChanged: (index, value) {
                  setState(() {
                    _arePeriodsRegular = index == 0;
                  });
                },
              ),
            ),
            _buildCard(
              '5. Gap between periods (days):',
              _buildTextField(_periodGapController, 'Enter number of days'),
            ),
            _buildCard(
              '6. Details of menstrual flow:',
              _buildRadioGroup(
                options: ['Light', 'Moderate', 'Heavy'],
                value: _crampSeverity,
                onChanged: (String? value) {
                  setState(() {
                    _crampSeverity = value ?? _crampSeverity;
                  });
                },
              ),
            ),
            _buildCard(
              '7. Do you experience cramps?',
              Column(
                children: [
                  SwitchListTile(
                    title: const Text('Cramps'),
                    value: _hasCramps,
                    onChanged: (value) {
                      setState(() {
                        _hasCramps = value;
                      });
                    },
                  ),
                  if (_hasCramps) ...[
                    _buildDropdown(
                      title: 'Rate severity of cramps:',
                      options: ['Mild', 'Moderate', 'Severe'],
                      value: _crampSeverity,
                      onChanged: (value) {
                        setState(() {
                          _crampSeverity = value!;
                        });
                      },
                    ),
                    _buildTextField(_crampMedicationController, 'Enter medication (if any)'),
                  ],
                ],
              ),
            ),
            _buildCard(
              '8. Do you experience spotting?',
              SwitchListTile(
                title: const Text('Spotting'),
                value: _spotting,
                onChanged: (value) {
                  setState(() {
                    _spotting = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _saveMenstrualData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PregnancyHistoryPage()),
                  );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  Widget _buildCheckboxRow({
    required List<String> options,
    required List<bool> values,
    required Function(int, bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(options.length, (index) {
        return Row(
          children: [
            Checkbox(
              value: values[index],
              onChanged: (value) => onChanged(index, value ?? false),
            ),
            Text(options[index]),
          ],
        );
      }),
    );
  }

  Widget _buildRadioGroup({
    required List<String> options,
    required String value,
    required void Function(String?) onChanged, // Allow nullable String
  }) {
    return Column(
      children: options
          .map((option) => RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: value,
        onChanged: onChanged, // Corrected the type here
      ))
          .toList(),
    );
  }


  Widget _buildDropdown({
    required String title,
    required List<String> options,
    required String value,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: options
              .map((option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _saveMenstrualData() async {
    // Same logic as before for saving data
  }

  @override
  void dispose() {
    _ageController.dispose();
    _lastPeriodController.dispose();
    _periodGapController.dispose();
    _crampMedicationController.dispose();
    super.dispose();
  }
}
