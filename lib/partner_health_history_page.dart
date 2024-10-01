import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import this for file path access
import 'family_history_page.dart';

class PartnersHealthHistoryPage extends StatefulWidget {
  const PartnersHealthHistoryPage({super.key});

  @override
  _PartnersHealthHistoryPageState createState() => _PartnersHealthHistoryPageState();
}

class _PartnersHealthHistoryPageState extends State<PartnersHealthHistoryPage> {
  bool _semenAnalysisDone = false;
  bool _semenAnalysisNormal = false;
  bool _partnerSeeingDoctor = false;
  bool _fatheredChild = false;
  bool _diagnosedWithConditions = false;

  final TextEditingController _spermCountController = TextEditingController();
  final TextEditingController _spermMotilityController = TextEditingController();
  final TextEditingController _tziController = TextEditingController();
  final TextEditingController _utiTestController = TextEditingController();
  final TextEditingController _wbcController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _fatheredChildDateController = TextEditingController();
  final TextEditingController _conditionDetailsController = TextEditingController();
  final TextEditingController _prescribedDrugsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partner's Health History"),
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
              'VII. Partner’s Health History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Semen Analysis Question
            const Text('Has your partner had a semen analysis?'),
            Row(
              children: [
                Checkbox(
                  value: _semenAnalysisDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _semenAnalysisDone = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_semenAnalysisDone,
                  onChanged: (bool? value) {
                    setState(() {
                      _semenAnalysisDone = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_semenAnalysisDone)
              Row(
                children: [
                  Checkbox(
                    value: _semenAnalysisNormal,
                    onChanged: (bool? value) {
                      setState(() {
                        _semenAnalysisNormal = value ?? false;
                      });
                    },
                  ),
                  const Text('Normal'),
                  Checkbox(
                    value: !_semenAnalysisNormal,
                    onChanged: (bool? value) {
                      setState(() {
                        _semenAnalysisNormal = !(value ?? true);
                      });
                    },
                  ),
                  const Text('Abnormal'),
                ],
              ),

            // Sperm Analysis Stats
            if (_semenAnalysisDone) ...[
              buildQuestionField('Sperm count:', _spermCountController),
              buildQuestionField('Sperm motility:', _spermMotilityController),
              buildQuestionField('TZI (Teratozoospermia index) levels:', _tziController),
              buildQuestionField('UTI test:', _utiTestController),
              buildQuestionField('White blood cells:', _wbcController),
            ],

            const SizedBox(height: 16),

            // Partner Seeing Doctor Question
            const Text('Is your partner seeing a doctor for evaluation of infertility?'),
            Row(
              children: [
                Checkbox(
                  value: _partnerSeeingDoctor,
                  onChanged: (bool? value) {
                    setState(() {
                      _partnerSeeingDoctor = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_partnerSeeingDoctor,
                  onChanged: (bool? value) {
                    setState(() {
                      _partnerSeeingDoctor = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_partnerSeeingDoctor)
              buildQuestionField('If yes, what is the diagnosis and how is he being treated?', _diagnosisController),

            const SizedBox(height: 16),

            // Fathered Child Question
            const Text('Has he ever fathered a child previously, either with you or with other women?'),
            Row(
              children: [
                Checkbox(
                  value: _fatheredChild,
                  onChanged: (bool? value) {
                    setState(() {
                      _fatheredChild = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_fatheredChild,
                  onChanged: (bool? value) {
                    setState(() {
                      _fatheredChild = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_fatheredChild)
              buildQuestionField('If yes, when?', _fatheredChildDateController),

            const SizedBox(height: 16),

            // Tuberculosis/UTI/STD Question
            const Text('Is your partner ever diagnosed with Tuberculosis/UTI/STD?'),
            Row(
              children: [
                Checkbox(
                  value: _diagnosedWithConditions,
                  onChanged: (bool? value) {
                    setState(() {
                      _diagnosedWithConditions = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_diagnosedWithConditions,
                  onChanged: (bool? value) {
                    setState(() {
                      _diagnosedWithConditions = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_diagnosedWithConditions) ...[
              buildQuestionField('If Yes, mention details:', _conditionDetailsController),
              buildQuestionField('Prescribed drugs/duration of therapy:', _prescribedDrugsController),
            ],

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _saveData(); // Call the save data function
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FamilyHistoryPage()),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
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
    Map<String, dynamic> partnerData = {
      'semen_analysis_done': _semenAnalysisDone,
      'semen_analysis_normal': _semenAnalysisNormal,
      'sperm_count': _spermCountController.text,
      'sperm_motility': _spermMotilityController.text,
      'tzi_levels': _tziController.text,
      'uti_test': _utiTestController.text,
      'white_blood_cells': _wbcController.text,
      'partner_seeing_doctor': _partnerSeeingDoctor,
      'diagnosis': _diagnosisController.text,
      'fathered_child': _fatheredChild,
      'fathered_child_date': _fatheredChildDateController.text,
      'diagnosed_with_conditions': _diagnosedWithConditions,
      'condition_details': _conditionDetailsController.text,
      'prescribed_drugs': _prescribedDrugsController.text,
    };

    // Merge new data with existing data
    data['partner_health_history'] = partnerData;

    // Write updated data back to the file
    await file.writeAsString(json.encode(data), flush: true);
  }

  @override
  void dispose() {
    _spermCountController.dispose();
    _spermMotilityController.dispose();
    _tziController.dispose();
    _utiTestController.dispose();
    _wbcController.dispose();
    _diagnosisController.dispose();
    _fatheredChildDateController.dispose();
    _conditionDetailsController.dispose();
    _prescribedDrugsController.dispose();
    super.dispose();
  }
}
