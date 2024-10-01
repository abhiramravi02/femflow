import 'package:flutter/material.dart';
import 'menstrual_history_page.dart';

class GeneralHealthDetailsPage extends StatefulWidget {
  const GeneralHealthDetailsPage({super.key});

  @override
  _GeneralHealthDetailsPageState createState() => _GeneralHealthDetailsPageState();
}

class _GeneralHealthDetailsPageState extends State<GeneralHealthDetailsPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _bloodType = 'A+';
  bool _exercises = false;
  final TextEditingController _exerciseDetailsController = TextEditingController();
  bool _addictions = false;
  final TextEditingController _addictionDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Health Details'),
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
            buildQuestionField('1. Height (cms):', _heightController),
            const SizedBox(height: 16),
            buildQuestionField('2. Weight (kgs):', _weightController),
            const SizedBox(height: 16),
            const Text('3. Blood Type:'),
            DropdownButton<String>(
              value: _bloodType,
              items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _bloodType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('4. Do you exercise/workout?'),
            Row(
              children: [
                Checkbox(
                  value: _exercises,
                  onChanged: (bool? value) {
                    setState(() {
                      _exercises = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_exercises,
                  onChanged: (bool? value) {
                    setState(() {
                      _exercises = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_exercises) ...[
              const Text('List of exercises and duration:'),
              TextField(
                controller: _exerciseDetailsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your exercise details',
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Text('5. Any addictions (caffeine/tobacco/alcohol/drug abuse):'),
            Row(
              children: [
                Checkbox(
                  value: _addictions,
                  onChanged: (bool? value) {
                    setState(() {
                      _addictions = value ?? false;
                    });
                  },
                ),
                const Text('Yes'),
                Checkbox(
                  value: !_addictions,
                  onChanged: (bool? value) {
                    setState(() {
                      _addictions = !(value ?? true);
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (_addictions) ...[
              const Text('Please specify:'),
              TextField(
                controller: _addictionDetailsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter addiction details',
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to Menstrual History Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenstrualHistoryPage()),
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
      ],
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _exerciseDetailsController.dispose();
    _addictionDetailsController.dispose();
    super.dispose();
  }
}
