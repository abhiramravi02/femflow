import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import this for file path access

class FamilyHistoryPage extends StatefulWidget {
  const FamilyHistoryPage({super.key});

  @override
  _FamilyHistoryPageState createState() => _FamilyHistoryPageState();
}

class _FamilyHistoryPageState extends State<FamilyHistoryPage> {
  bool _motherHadIssues = false;
  bool _familyHistoryInfertility = false;
  bool _familyHistoryConditions = false;

  final TextEditingController _motherIssuesDetailsController = TextEditingController();
  final TextEditingController _familyInfertilityDetailsController = TextEditingController();
  final TextEditingController _familyHistoryOtherController = TextEditingController();

  // Family history conditions
  bool _hasBleedingTendencies = false;
  bool _hasStrokes = false;
  bool _hasCancer = false;
  bool _hasThyroidDisorders = false;
  bool _hasDiabetes = false;
  bool _hasTuberculosis = false;
  bool _hasHPV = false;
  bool _hasHCV = false;
  bool _hasHIV = false;
  bool _hasHeartDisease = false;
  bool _hasHighBloodPressure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Family History"),
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
            const Text(
              'VIII. Family History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Mother's conception or pregnancy issues
            const Text('1. Did your mother have any difficulty with conception, pregnancy, abortions, or pre-term birth?'),
            Row(
              children: [
                Checkbox(
                  value: _motherHadIssues,
                  onChanged: (bool? value) {
                    setState(() {
                      _motherHadIssues = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_motherHadIssues,
                  onChanged: (bool? value) {
                    setState(() {
                      _motherHadIssues = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_motherHadIssues)
              buildQuestionField('If yes, give details:', _motherIssuesDetailsController),

            const SizedBox(height: 16),

            // Family history of infertility
            const Text('2. Is there a family history of infertility?'),
            Row(
              children: [
                Checkbox(
                  value: _familyHistoryInfertility,
                  onChanged: (bool? value) {
                    setState(() {
                      _familyHistoryInfertility = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_familyHistoryInfertility,
                  onChanged: (bool? value) {
                    setState(() {
                      _familyHistoryInfertility = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_familyHistoryInfertility)
              buildQuestionField('If yes, list all members and relationship to you:', _familyInfertilityDetailsController),

            const SizedBox(height: 16),

            // Family history of specific conditions
            const Text('3. Is there a family history (mother and father side) of the following conditions?'),
            buildConditionCheckbox('Bleeding tendencies', _hasBleedingTendencies, (value) {
              setState(() {
                _hasBleedingTendencies = value!;
              });
            }),
            buildConditionCheckbox('Strokes', _hasStrokes, (value) {
              setState(() {
                _hasStrokes = value!;
              });
            }),
            buildConditionCheckbox('Cancer', _hasCancer, (value) {
              setState(() {
                _hasCancer = value!;
              });
            }),
            buildConditionCheckbox('Thyroid disorders', _hasThyroidDisorders, (value) {
              setState(() {
                _hasThyroidDisorders = value!;
              });
            }),
            buildConditionCheckbox('Diabetes', _hasDiabetes, (value) {
              setState(() {
                _hasDiabetes = value!;
              });
            }),
            buildConditionCheckbox('Tuberculosis', _hasTuberculosis, (value) {
              setState(() {
                _hasTuberculosis = value!;
              });
            }),
            buildConditionCheckbox('HPV', _hasHPV, (value) {
              setState(() {
                _hasHPV = value!;
              });
            }),
            buildConditionCheckbox('HCV', _hasHCV, (value) {
              setState(() {
                _hasHCV = value!;
              });
            }),
            buildConditionCheckbox('HIV', _hasHIV, (value) {
              setState(() {
                _hasHIV = value!;
              });
            }),
            buildConditionCheckbox('Heart Disease', _hasHeartDisease, (value) {
              setState(() {
                _hasHeartDisease = value!;
              });
            }),
            buildConditionCheckbox('High Blood Pressure', _hasHighBloodPressure, (value) {
              setState(() {
                _hasHighBloodPressure = value!;
              });
            }),

            const SizedBox(height: 16),

            // Other conditions
            buildQuestionField('Other (Specify):', _familyHistoryOtherController),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _saveData(); // Call the save data function
                print("Submitted");
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConditionCheckbox(String condition, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(condition),
      ],
    );
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
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _saveData() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/user_data.json';
    File file = File(filePath);

    // Check if the file exists
    if (!(await file.exists())) {
      await file.create(); // Create the file if it doesn't exist
    }

    // Read the existing data from the file
    String existingData = await file.readAsString();
    Map<String, dynamic> data = existingData.isNotEmpty ? json.decode(existingData) : {};

    // Create a map for the new data
    Map<String, dynamic> familyData = {
      'mother_had_issues': _motherHadIssues,
      'mother_issues_details': _motherIssuesDetailsController.text,
      'family_history_infertility': _familyHistoryInfertility,
      'family_infertility_details': _familyInfertilityDetailsController.text,
      'bleeding_tendencies': _hasBleedingTendencies,
      'strokes': _hasStrokes,
      'cancer': _hasCancer,
      'thyroid_disorders': _hasThyroidDisorders,
      'diabetes': _hasDiabetes,
      'tuberculosis': _hasTuberculosis,
      'hpv': _hasHPV,
      'hcv': _hasHCV,
      'hiv': _hasHIV,
      'heart_disease': _hasHeartDisease,
      'high_blood_pressure': _hasHighBloodPressure,
      'other_conditions': _familyHistoryOtherController.text,
    };

    // Merge new data with existing data
    data['family_history'] = familyData;

    // Write updated data back to the file
    await file.writeAsString(json.encode(data), flush: true);
  }

  @override
  void dispose() {
    _motherIssuesDetailsController.dispose();
    _familyInfertilityDetailsController.dispose();
    _familyHistoryOtherController.dispose();
    super.dispose();
  }
}
