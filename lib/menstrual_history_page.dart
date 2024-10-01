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
  final TextEditingController _flowDurationController = TextEditingController();
  bool _hasCramps = false;
  String _crampSeverity = 'Mild';
  final TextEditingController _crampMedicationController = TextEditingController();
  bool _spotting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstrual History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildQuestionField('1. Age at first period (yrs)?', _ageController),
            const SizedBox(height: 16),
            buildQuestionField('2. First day of your last period?', _lastPeriodController),
            const SizedBox(height: 16),
            const Text('Normal / Abnormal'),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isPeriodNormal,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPeriodNormal = value ?? true;
                          });
                        },
                      ),
                      const Text('Normal'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: !_isPeriodNormal,
                        onChanged: (bool? value) {
                          setState(() {
                            _isPeriodNormal = !(value ?? true);
                          });
                        },
                      ),
                      const Text('Abnormal'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('3. Are your periods regular?'),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _arePeriodsRegular,
                        onChanged: (bool? value) {
                          setState(() {
                            _arePeriodsRegular = value ?? true;
                          });
                        },
                      ),
                      const Text('Yes'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: !_arePeriodsRegular,
                        onChanged: (bool? value) {
                          setState(() {
                            _arePeriodsRegular = !(value ?? true);
                          });
                        },
                      ),
                      const Text('No'),
                    ],
                  ),
                ),
              ],
            ),
            buildQuestionField('4. Mention the gap between periods (days):', _periodGapController),
            const SizedBox(height: 16),
            const Text('5. Details of menstrual flow'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    value: 'Light',
                    groupValue: _crampSeverity,
                    title: const Text('Light'),
                    onChanged: (value) {
                      setState(() {
                        _crampSeverity = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: 'Moderate',
                    groupValue: _crampSeverity,
                    title: const Text('Moderate'),
                    onChanged: (value) {
                      setState(() {
                        _crampSeverity = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: 'Heavy',
                    groupValue: _crampSeverity,
                    title: const Text('Heavy'),
                    onChanged: (value) {
                      setState(() {
                        _crampSeverity = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('6. Do you experience cramps?'),
            Checkbox(
              value: _hasCramps,
              onChanged: (bool? value) {
                setState(() {
                  _hasCramps = value ?? false;
                });
              },
            ),
            if (_hasCramps) ...[
              const Text('7. Rate the severity of your cramps:'),
              DropdownButton<String>(
                value: _crampSeverity,
                items: <String>['Mild', 'Moderate', 'Severe']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _crampSeverity = value!;
                  });
                },
              ),
              buildQuestionField('8. What medication do you take?', _crampMedicationController),
            ],
            const SizedBox(height: 16),
            const Text('9. Do you experience spotting?'),
            Checkbox(
              value: _spotting,
              onChanged: (bool? value) {
                setState(() {
                  _spotting = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveMenstrualData(); // Save the data before navigating
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PregnancyHistoryPage()),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save menstrual history data to user_data.json
  Future<void> _saveMenstrualData() async {
    try {
      // Get the directory where the app can store files
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_data.json';

      // Create the file if it doesn't exist
      File file = File(filePath);
      if (!await file.exists()) {
        await file.create();
        await file.writeAsString(jsonEncode({})); // Initialize with an empty JSON object
      }

      // Read the existing JSON data from the file
      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Create menstrual history data entry
      Map<String, dynamic> menstrualHistoryData = {
        'menstrual_history': {
          'age_at_first_period': _ageController.text,
          'last_period_date': _lastPeriodController.text,
          'is_period_normal': _isPeriodNormal,
          'are_periods_regular': _arePeriodsRegular,
          'period_gap': _periodGapController.text,
          'cramp_severity': _crampSeverity,
          'has_cramps': _hasCramps,
          'cramp_medication': _crampMedicationController.text,
          'spotting': _spotting,
        },
      };

      // Check if 'menstrual_history' exists
      if (jsonData.containsKey('menstrual_history')) {
        // If it exists, update the existing data
        jsonData['menstrual_history'] = menstrualHistoryData['menstrual_history'];
      } else {
        // If it doesn't exist, add the new data
        jsonData['menstrual_history'] = menstrualHistoryData['menstrual_history'];
      }

      // Write the updated JSON data back to the file
      await file.writeAsString(jsonEncode(jsonData));

      print('Menstrual history data saved successfully at $filePath');
    } catch (e) {
      print('Error saving menstrual history data: $e');
    }
  }

  Widget buildQuestionField(String question, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 16),
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your answer',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _lastPeriodController.dispose();
    _periodGapController.dispose();
    _flowDurationController.dispose();
    _crampMedicationController.dispose();
    super.dispose();
  }
}
