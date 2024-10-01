import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SubmitData {
  // Method to store data into a local JSON file
  Future<void> saveDataLocally(Map<String, dynamic> formData) async {
    try {
      // Get the directory where the file will be saved
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Create the JSON file
      File file = File('$path/answers.json');

      // Convert the form data to JSON format
      String jsonData = jsonEncode(formData);

      // Write the data to the file
      await file.writeAsString(jsonData);

      print("Data saved locally at $path/answers.json");
    } catch (e) {
      print("Failed to save data locally: $e");
    }
  }
}
