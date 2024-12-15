import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'submit_data.dart'; // Import the SubmitData class
import 'package:path_provider/path_provider.dart'; // Import this for file path access

class MediaPickerPage extends StatefulWidget {
  const MediaPickerPage({super.key});

  @override
  _MediaPickerPageState createState() => _MediaPickerPageState();
}

class _MediaPickerPageState extends State<MediaPickerPage> {
  List<File> _images = []; // List to store selected images

  // Function to pick multiple images
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Function to handle submit
  void _submitData() async {
    if (_images.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_data.json';
      File file = File(filePath);

      if (await file.exists()) {
        String jsonData = await file.readAsString();
        final Map<String, dynamic> data = json.decode(jsonData);

        SubmitData submitData = SubmitData();
        await submitData.convertJsonToPdf(data, _images);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF has been saved in downloads')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('JSON file not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Media',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _pickImages,
              child: const Text('Pick Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // Display selected images
            if (_images.isNotEmpty)
              ..._images.map(
                    (image) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image, height: 150, width: 150, fit: BoxFit.cover),
                  ),
                ),
              ).toList(),
            if (_images.isEmpty)
              const Text('No images selected',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _submitData,
              child: const Text('Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
