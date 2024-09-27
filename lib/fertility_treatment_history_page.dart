import 'package:flutter/material.dart';
import 'partner_health_history_page.dart';

class FertilityTreatmentHistoryPage extends StatefulWidget {
  const FertilityTreatmentHistoryPage({super.key});

  @override
  _FertilityTreatmentHistoryPageState createState() => _FertilityTreatmentHistoryPageState();
}

class _FertilityTreatmentHistoryPageState extends State<FertilityTreatmentHistoryPage> {
  bool _treatedForInfertility = false;
  final TextEditingController _physicianController = TextEditingController();
  final TextEditingController _diagnosedCauseController = TextEditingController();
  final TextEditingController _iuiCyclesController = TextEditingController();
  final TextEditingController _iuiDatesController = TextEditingController();
  final TextEditingController _clomidAloneController = TextEditingController();
  final TextEditingController _clomidAloneDatesController = TextEditingController();
  final TextEditingController _clomidWithIuiController = TextEditingController();
  final TextEditingController _clomidWithIuiDatesController = TextEditingController();
  final TextEditingController _hcgInjectionsController = TextEditingController();
  final TextEditingController _hcgInjectionsDatesController = TextEditingController();
  final TextEditingController _ivfCyclesController = TextEditingController();
  final TextEditingController _ivfCyclesDatesController = TextEditingController();
  final TextEditingController _frozenEmbryoCyclesController = TextEditingController();
  final TextEditingController _frozenEmbryoDatesController = TextEditingController();
  final TextEditingController _canceledIvfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertility Treatment History'),
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
            const Text('1. Have you been treated for infertility before?'),
            Row(
              children: [
                Checkbox(
                  value: _treatedForInfertility,
                  onChanged: (bool? value) {
                    setState(() {
                      _treatedForInfertility = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_treatedForInfertility,
                  onChanged: (bool? value) {
                    setState(() {
                      _treatedForInfertility = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_treatedForInfertility) ...[
              buildQuestionField('If yes, who was your physician?', _physicianController),
              buildQuestionField('Diagnosed cause?', _diagnosedCauseController),
              const SizedBox(height: 16),
              const Text('Treatment History'),
              buildTreatmentHistoryField('Intrauterine insemination', _iuiCyclesController, _iuiDatesController),
              buildTreatmentHistoryField('Clomid/Letrozole alone', _clomidAloneController, _clomidAloneDatesController),
              buildTreatmentHistoryField('Clomid/Letrozole with intrauterine insemination', _clomidWithIuiController, _clomidWithIuiDatesController),
              buildTreatmentHistoryField('Daily hCG injections/intrauterine insemination', _hcgInjectionsController, _hcgInjectionsDatesController),
              buildTreatmentHistoryField('Completed IVF cycles', _ivfCyclesController, _ivfCyclesDatesController),
              buildTreatmentHistoryField('Frozen embryo cycles', _frozenEmbryoCyclesController, _frozenEmbryoDatesController),
              buildTreatmentHistoryField('Canceled IVF attempts', _canceledIvfController, null),
            ],
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PartnersHealthHistoryPage()),
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

  Widget buildTreatmentHistoryField(String treatmentName, TextEditingController cyclesController, TextEditingController? datesController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$treatmentName (# Cycles and Dates)'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cyclesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Number of cycles',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            if (datesController != null)
              Expanded(
                child: TextField(
                  controller: datesController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Dates (from/to)',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Outcome: Pregnant/Delivered/Ectopic/Miscarriage/Not pregnant'),
      ],
    );
  }

  @override
  void dispose() {
    _physicianController.dispose();
    _diagnosedCauseController.dispose();
    _iuiCyclesController.dispose();
    _iuiDatesController.dispose();
    _clomidAloneController.dispose();
    _clomidAloneDatesController.dispose();
    _clomidWithIuiController.dispose();
    _clomidWithIuiDatesController.dispose();
    _hcgInjectionsController.dispose();
    _hcgInjectionsDatesController.dispose();
    _ivfCyclesController.dispose();
    _ivfCyclesDatesController.dispose();
    _frozenEmbryoCyclesController.dispose();
    _frozenEmbryoDatesController.dispose();
    _canceledIvfController.dispose();
    super.dispose();
  }
}
