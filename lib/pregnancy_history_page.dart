import 'package:flutter/material.dart';
import 'contraceptive_sexual_history_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PregnancyHistoryPage extends StatefulWidget {
  const PregnancyHistoryPage({super.key});

  @override
  _PregnancyHistoryPageState createState() => _PregnancyHistoryPageState();
}

class _PregnancyHistoryPageState extends State<PregnancyHistoryPage> {
  bool _hadTermPregnancies = false;
  final TextEditingController _termPregnanciesController = TextEditingController();

  bool _hadPretermPregnancies = false;
  final TextEditingController _pretermHealthDetailsController = TextEditingController();

  bool _hadNaturalAbortions = false;
  final TextEditingController _naturalAbortionsCountController = TextEditingController();

  bool _hadMedicalAbortions = false;
  final TextEditingController _medicalAbortionsCountController = TextEditingController();

  bool _hadEctopicPregnancies = false;
  final TextEditingController _ectopicPregnanciesCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy History'),
        backgroundColor: Colors.teal, // Set a color like in the previous page
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
            _buildCard(
              'a) Did you have term pregnancies previously?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                value: _hadTermPregnancies,
                onChanged: (value) {
                  setState(() {
                    _hadTermPregnancies = value;
                  });
                },
              ),
              controller: _termPregnanciesController,
              showTextField: _hadTermPregnancies,
            ),
            const SizedBox(height: 16),
            _buildCard(
              'b) Did you have preterm pregnancies/deliveries previously?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                value: _hadPretermPregnancies,
                onChanged: (value) {
                  setState(() {
                    _hadPretermPregnancies = value;
                  });
                },
              ),
              controller: _pretermHealthDetailsController,
              showTextField: _hadPretermPregnancies,
            ),
            const SizedBox(height: 16),
            _buildCard(
              'c) Did you have natural abortions earlier?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                value: _hadNaturalAbortions,
                onChanged: (value) {
                  setState(() {
                    _hadNaturalAbortions = value;
                  });
                },
              ),
              controller: _naturalAbortionsCountController,
              showTextField: _hadNaturalAbortions,
            ),
            const SizedBox(height: 16),
            _buildCard(
              'd) Did you have medical termination of pregnancy (medical abortions) previously?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                value: _hadMedicalAbortions,
                onChanged: (value) {
                  setState(() {
                    _hadMedicalAbortions = value;
                  });
                },
              ),
              controller: _medicalAbortionsCountController,
              showTextField: _hadMedicalAbortions,
            ),
            const SizedBox(height: 16),
            _buildCard(
              'e) Did you have Ectopic pregnancy/tubal pregnancy previously?',
              _buildCheckboxRow(
                options: ['Yes', 'No'],
                value: _hadEctopicPregnancies,
                onChanged: (value) {
                  setState(() {
                    _hadEctopicPregnancies = value;
                  });
                },
              ),
              controller: _ectopicPregnanciesCountController,
              showTextField: _hadEctopicPregnancies,
            ),
            const SizedBox(height: 32),
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
                  _savePregnancyData(); // Save the data before navigating
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContraceptiveSexualHistoryPage()),
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child, {TextEditingController? controller, bool showTextField = false}) {
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
            if (showTextField)
              _buildTextField(controller!),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow({
    required List<String> options,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(options.length, (index) {
        return Row(
          children: [
            Checkbox(
              value: index == 0 ? value : !value,
              onChanged: (value) => onChanged(index == 0),
            ),
            Text(options[index]),
          ],
        );
      }),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your answer',
        ),
      ),
    );
  }

  Future<void> _savePregnancyData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_data.json';
      File file = File(filePath);

      if (!await file.exists()) {
        await file.create();
        await file.writeAsString(jsonEncode({}));
      }

      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      Map<String, dynamic> pregnancyHistoryData = {
        'pregnancy_history': {
          'had_term_pregnancies': _hadTermPregnancies,
          'term_pregnancies_count': _hadTermPregnancies ? _termPregnanciesController.text : null,
          'had_preterm_pregnancies': _hadPretermPregnancies,
          'preterm_health_details': _hadPretermPregnancies ? _pretermHealthDetailsController.text : null,
          'had_natural_abortions': _hadNaturalAbortions,
          'natural_abortions_count': _hadNaturalAbortions ? _naturalAbortionsCountController.text : null,
          'had_medical_abortions': _hadMedicalAbortions,
          'medical_abortions_count': _hadMedicalAbortions ? _medicalAbortionsCountController.text : null,
          'had_ectopic_pregnancies': _hadEctopicPregnancies,
          'ectopic_pregnancies_count': _hadEctopicPregnancies ? _ectopicPregnanciesCountController.text : null,
        },
      };

      if (jsonData.containsKey('pregnancy_history')) {
        jsonData['pregnancy_history'] = pregnancyHistoryData['pregnancy_history'];
      } else {
        jsonData['pregnancy_history'] = pregnancyHistoryData['pregnancy_history'];
      }

      await file.writeAsString(jsonEncode(jsonData));

      print('Pregnancy history data saved successfully at $filePath');
    } catch (e) {
      print('Error saving pregnancy history data: $e');
    }
  }

  @override
  void dispose() {
    _termPregnanciesController.dispose();
    _pretermHealthDetailsController.dispose();
    _naturalAbortionsCountController.dispose();
    _medicalAbortionsCountController.dispose();
    _ectopicPregnanciesCountController.dispose();
    super.dispose();
  }
}
