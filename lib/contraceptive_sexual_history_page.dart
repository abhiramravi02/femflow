import 'package:flutter/material.dart';
import 'fertility_treatment_history_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ContraceptiveSexualHistoryPage extends StatefulWidget {
  const ContraceptiveSexualHistoryPage({super.key});

  @override
  _ContraceptiveSexualHistoryPageState createState() => _ContraceptiveSexualHistoryPageState();
}

class _ContraceptiveSexualHistoryPageState extends State<ContraceptiveSexualHistoryPage> {
  final List<String> _contraceptionMethods = [
    'Pills', 'IUD', 'Diaphragm', 'Rhythm',
    'Withdrawal', 'Foams/Jellies/Condom', 'Tubal ligation', 'Vasectomy'
  ];
  final List<String> _selectedContraceptionMethods = [];
  bool _periodsRegularAfterPills = false;
  bool _timeIntercourseAroundOvulation = false;
  final TextEditingController _ovulationTimingDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contraceptive / Sexual History'),
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
            const Text('1. What form of contraception do you use now or have you used in the past?'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10.0,
              children: _contraceptionMethods.map((method) {
                return FilterChip(
                  label: Text(method),
                  selected: _selectedContraceptionMethods.contains(method),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedContraceptionMethods.add(method);
                      } else {
                        _selectedContraceptionMethods.remove(method);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text('2. If you\'ve ever been on oral contraceptives (pills), were your periods regular after stopping the pills?'),
            Row(
              children: [
                Checkbox(
                  value: _periodsRegularAfterPills,
                  onChanged: (bool? value) {
                    setState(() {
                      _periodsRegularAfterPills = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_periodsRegularAfterPills,
                  onChanged: (bool? value) {
                    setState(() {
                      _periodsRegularAfterPills = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 16),

            const Text('3. Do you time intercourse around ovulation?'),
            Row(
              children: [
                Checkbox(
                  value: _timeIntercourseAroundOvulation,
                  onChanged: (bool? value) {
                    setState(() {
                      _timeIntercourseAroundOvulation = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_timeIntercourseAroundOvulation,
                  onChanged: (bool? value) {
                    setState(() {
                      _timeIntercourseAroundOvulation = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_timeIntercourseAroundOvulation)
              buildQuestionField('If yes, how?', _ovulationTimingDetailsController),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                _saveContraceptiveData(); // Save the data before navigating
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FertilityTreatmentHistoryPage()),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save contraceptive and sexual history data to user_data.json
  Future<void> _saveContraceptiveData() async {
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

      // Create contraceptive and sexual history data entry
      Map<String, dynamic> contraceptiveData = {
        'contraceptive_sexual_history': {
          'methods_used': _selectedContraceptionMethods,
          'periods_regular_after_pills': _periodsRegularAfterPills,
          'timing_intercourse_around_ovulation': _timeIntercourseAroundOvulation,
          'ovulation_timing_details': _timeIntercourseAroundOvulation ? _ovulationTimingDetailsController.text : null,
        },
      };

      // Check if 'contraceptive_sexual_history' exists
      if (jsonData.containsKey('contraceptive_sexual_history')) {
        // If it exists, update the existing data
        jsonData['contraceptive_sexual_history'] = contraceptiveData['contraceptive_sexual_history'];
      } else {
        // If it doesn't exist, add the new data
        jsonData['contraceptive_sexual_history'] = contraceptiveData['contraceptive_sexual_history'];
      }

      // Write the updated JSON data back to the file
      await file.writeAsString(jsonEncode(jsonData));

      print('Contraceptive and sexual history data saved successfully at $filePath');
    } catch (e) {
      print('Error saving contraceptive and sexual history data: $e');
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
    _ovulationTimingDetailsController.dispose();
    super.dispose();
  }
}
