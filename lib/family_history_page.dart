import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'media_picker.dart';

class FamilyHistoryPage extends StatefulWidget {
  const FamilyHistoryPage({super.key});

  @override
  _FamilyHistoryPageState createState() => _FamilyHistoryPageState();
}

class _FamilyHistoryPageState extends State<FamilyHistoryPage> {
  // State variables
  bool _motherHadIssues = false;
  bool _familyHistoryInfertility = false;

  // Controllers
  final TextEditingController _motherIssuesDetailsController = TextEditingController();
  final TextEditingController _familyInfertilityDetailsController = TextEditingController();
  final TextEditingController _familyHistoryOtherController = TextEditingController();

  // Conditions
  final Map<String, bool> _conditions = {
    'Bleeding Tendencies': false,
    'Strokes': false,
    'Cancer': false,
    'Thyroid Disorders': false,
    'Diabetes': false,
    'Tuberculosis': false,
    'HPV': false,
    'HCV': false,
    'HIV': false,
    'Heart Disease': false,
    'High Blood Pressure': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Family History',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              buildQuestionCard(
                '1. Did your mother have any difficulty with conception, pregnancy, abortions, or pre-term birth?',
                CheckboxListTile(
                  title: const Text('Yes', style: TextStyle(fontSize: 16)),
                  value: _motherHadIssues,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.teal,
                  onChanged: (value) {
                    setState(() {
                      _motherHadIssues = value!;
                    });
                  },
                ),
                _motherHadIssues
                    ? buildTextField('If yes, give details:', _motherIssuesDetailsController)
                    : null,
              ),

              const SizedBox(height: 20),

              buildQuestionCard(
                '2. Is there a family history of infertility?',
                CheckboxListTile(
                  title: const Text('Yes', style: TextStyle(fontSize: 16)),
                  value: _familyHistoryInfertility,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.teal,
                  onChanged: (value) {
                    setState(() {
                      _familyHistoryInfertility = value!;
                    });
                  },
                ),
                _familyHistoryInfertility
                    ? buildTextField('If yes, list all members and relationship to you:',
                    _familyInfertilityDetailsController)
                    : null,
              ),

              const SizedBox(height: 20),

              buildQuestionCard(
                '3. Is there a family history (mother and father side) of the following conditions?',
                Column(
                  children: _conditions.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.key, style: const TextStyle(fontSize: 16)),
                      value: entry.value,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.teal,
                      onChanged: (value) {
                        setState(() {
                          _conditions[entry.key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              buildQuestionCard(
                'Other (Specify):',
                buildTextField('', _familyHistoryOtherController),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await _saveData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MediaPickerPage()),
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionCard(String question, Widget child, [Widget? additionalWidget]) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            child,
            if (additionalWidget != null) ...[
              const SizedBox(height: 12),
              additionalWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Future<void> _saveData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_data.json';
      File file = File(filePath);

      if (!file.existsSync()) {
        await file.create();
        await file.writeAsString(jsonEncode({}));
      }

      String jsonString = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(jsonString);

      data['family_history'] = {
        'mother_had_issues': _motherHadIssues,
        'mother_issues_details': _motherIssuesDetailsController.text,
        'family_history_infertility': _familyHistoryInfertility,
        'family_infertility_details': _familyInfertilityDetailsController.text,
        'conditions': _conditions,
        'other_conditions': _familyHistoryOtherController.text,
      };

      await file.writeAsString(jsonEncode(data));
      print('Data saved successfully at $filePath');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  void dispose() {
    _motherIssuesDetailsController.dispose();
    _familyInfertilityDetailsController.dispose();
    _familyHistoryOtherController.dispose();
    super.dispose();
  }
}
