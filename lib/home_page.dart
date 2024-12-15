import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'menstrual_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _question1Controller = TextEditingController();
  final TextEditingController _question2Controller = TextEditingController();
  final TextEditingController _question3Controller = TextEditingController();
  final TextEditingController _question4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please fill out the form below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            buildQuestionCard('1. What is your name?', _question1Controller),
            const SizedBox(height: 16),
            buildQuestionCard('2. What is your age?', _question2Controller),
            const SizedBox(height: 16),
            buildQuestionCard('3. What is your favorite hobby?', _question3Controller),
            const SizedBox(height: 16),
            buildQuestionCard('4. What is your profession?', _question4Controller),
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
                onPressed: () async {
                  // Collect data from text fields
                  Map<String, String> homePageData = {
                    'name': _question1Controller.text,
                    'age': _question2Controller.text,
                    'hobby': _question3Controller.text,
                    'profession': _question4Controller.text,
                  };

                  // Save the data to a JSON file
                  await _saveDataToJson(homePageData);

                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenstrualHistoryPage()),
                  );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionCard(String question, TextEditingController controller) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDataToJson(Map<String, String> data) async {
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

      jsonData['home_page_data'] = data;

      await file.writeAsString(jsonEncode(jsonData));
      print('Data saved successfully at $filePath');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  void dispose() {
    _question1Controller.dispose();
    _question2Controller.dispose();
    _question3Controller.dispose();
    _question4Controller.dispose();
    super.dispose();
  }
}
