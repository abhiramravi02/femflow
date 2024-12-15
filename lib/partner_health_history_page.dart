import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partner's Health History"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            const Text(
              'Partner’s Health History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            buildCard(
              "Has your partner had a semen analysis?",
              Switch(
                value: _semenAnalysisDone,
                onChanged: (value) {
                  setState(() {
                    _semenAnalysisDone = value;
                  });
                },
              ),
              child: _semenAnalysisDone
                  ? Column(
                children: [
                  SwitchListTile(
                    title: const Text('Normal'),
                    value: _semenAnalysisNormal,
                    onChanged: (value) {
                      setState(() {
                        _semenAnalysisNormal = value;
                      });
                    },
                  ),
                  buildQuestionField('Sperm count:', _spermCountController),
                  buildQuestionField('Sperm motility:', _spermMotilityController),
                  buildQuestionField('TZI (Teratozoospermia index) levels:', _tziController),
                  buildQuestionField('UTI test:', _utiTestController),
                  buildQuestionField('White blood cells:', _wbcController),
                ],
              )
                  : null,
            ),

            buildCard(
              "Is your partner seeing a doctor for evaluation of infertility?",
              Switch(
                value: _partnerSeeingDoctor,
                onChanged: (value) {
                  setState(() {
                    _partnerSeeingDoctor = value;
                  });
                },
              ),
              child: _partnerSeeingDoctor
                  ? buildQuestionField('If yes, what is the diagnosis and how is he being treated?', _diagnosisController)
                  : null,
            ),

            buildCard(
              "Has he ever fathered a child previously, either with you or with other women?",
              Switch(
                value: _fatheredChild,
                onChanged: (value) {
                  setState(() {
                    _fatheredChild = value;
                  });
                },
              ),
              child: _fatheredChild
                  ? buildQuestionField('If yes, when?', _fatheredChildDateController)
                  : null,
            ),

            buildCard(
              "Is your partner ever diagnosed with Tuberculosis/UTI/STD?",
              Switch(
                value: _diagnosedWithConditions,
                onChanged: (value) {
                  setState(() {
                    _diagnosedWithConditions = value;
                  });
                },
              ),
              child: _diagnosedWithConditions
                  ? Column(
                children: [
                  buildQuestionField('If Yes, mention details:', _conditionDetailsController),
                  buildQuestionField('Prescribed drugs/duration of therapy:', _prescribedDrugsController),
                ],
              )
                  : null,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: screenWidth * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  _saveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FamilyHistoryPage()),
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

  Widget buildCard(String question, Widget trailing, {Widget? child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                trailing,
              ],
            ),
            if (child != null) ...[
              const SizedBox(height: 8),
              child,
            ],
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
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your answer',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _saveData() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/user_data.json';
    File file = File(filePath);

    if (!(await file.exists())) {
      await file.create();
    }

    String existingData = await file.readAsString();
    Map<String, dynamic> data = existingData.isNotEmpty ? json.decode(existingData) : {};

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

    data['partner_health_history'] = partnerData;

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
