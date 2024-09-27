import 'package:flutter/material.dart';
import 'contraceptive_sexual_history_page.dart';

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
            const Text('a) Did you have term pregnancies previously?'),
            Row(
              children: [
                Checkbox(
                  value: _hadTermPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadTermPregnancies = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_hadTermPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadTermPregnancies = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_hadTermPregnancies)
              buildQuestionField('If yes, then how many', _termPregnanciesController),
            const SizedBox(height: 16),

            const Text('b) Did you have preterm pregnancies/deliveries previously?'),
            Row(
              children: [
                Checkbox(
                  value: _hadPretermPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadPretermPregnancies = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_hadPretermPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadPretermPregnancies = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_hadPretermPregnancies)
              buildQuestionField('If yes, give details of health of the delivered baby', _pretermHealthDetailsController),
            const SizedBox(height: 16),

            const Text('c) Did you have natural abortions earlier?'),
            Row(
              children: [
                Checkbox(
                  value: _hadNaturalAbortions,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadNaturalAbortions = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_hadNaturalAbortions,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadNaturalAbortions = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_hadNaturalAbortions)
              buildQuestionField('If yes, how many', _naturalAbortionsCountController),
            const SizedBox(height: 16),

            const Text('d) Did you have medical termination of pregnancy (medical abortions) previously?'),
            Row(
              children: [
                Checkbox(
                  value: _hadMedicalAbortions,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadMedicalAbortions = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_hadMedicalAbortions,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadMedicalAbortions = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_hadMedicalAbortions)
              buildQuestionField('If yes, how many', _medicalAbortionsCountController),
            const SizedBox(height: 16),

            const Text('e) Did you have Ectopic pregnancy/tubal pregnancy previously?'),
            Row(
              children: [
                Checkbox(
                  value: _hadEctopicPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadEctopicPregnancies = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_hadEctopicPregnancies,
                  onChanged: (bool? value) {
                    setState(() {
                      _hadEctopicPregnancies = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_hadEctopicPregnancies)
              buildQuestionField('If yes, how many', _ectopicPregnanciesCountController),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
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
    _termPregnanciesController.dispose();
    _pretermHealthDetailsController.dispose();
    _naturalAbortionsCountController.dispose();
    _medicalAbortionsCountController.dispose();
    _ectopicPregnanciesCountController.dispose();
    super.dispose();
  }
}
