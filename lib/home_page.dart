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
        title: const Text('Home page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildQuestionField('1. What is your name?', _question1Controller),
            const SizedBox(height: 16),
            buildQuestionField('2. What is your age?', _question2Controller),
            const SizedBox(height: 16),
            buildQuestionField('3. What is your favorite hobby?', _question3Controller),
            const SizedBox(height: 16),
            buildQuestionField('4. What is your profession?', _question4Controller),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
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

  Future<void> _saveDataToJson(Map<String, String> data) async {
    try {
      // Get the directory where the app can store files
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_data.json';

      // Create the file if it doesn't exist
      File file = File(filePath);
      if (!await file.exists()) {
        // If file does not exist, create a new one
        await file.create();
        await file.writeAsString(jsonEncode({})); // Initialize with an empty JSON object
      }

      // Read the existing JSON data from the file
      String jsonString = await file.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Check if 'home_page_data' exists
      if (jsonData.containsKey('home_page_data')) {
        // If it exists, update the existing data
        jsonData['home_page_data'] = {
          'name': data['name'],
          'age': data['age'],
          'hobby': data['hobby'],
          'profession': data['profession'],
        };
      } else {
        // If it doesn't exist, add the new data
        jsonData['home_page_data'] = {
          'name': data['name'],
          'age': data['age'],
          'hobby': data['hobby'],
          'profession': data['profession'],
        };
      }

      // Write the updated JSON data back to the file
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
