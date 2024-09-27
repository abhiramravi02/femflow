import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitData {
  final Map<String, dynamic> homePageData;
  final Map<String, dynamic> generalHealthData;
  final Map<String, dynamic> menstrualHistoryData;
  final Map<String, dynamic> pregnancyHistoryData;
  final Map<String, dynamic> contraceptiveHistoryData;
  final Map<String, dynamic> fertilityTreatmentData;
  final Map<String, dynamic> partnerHealthData;
  final Map<String, dynamic> familyHistoryData;

  // Constructor to accept all data from different pages
  SubmitData({
    required this.homePageData,
    required this.generalHealthData,
    required this.menstrualHistoryData,
    required this.pregnancyHistoryData,
    required this.contraceptiveHistoryData,
    required this.fertilityTreatmentData,
    required this.partnerHealthData,
    required this.familyHistoryData,
  });

  // Function to submit data to Firebase Firestore
  Future<void> submitToFirebase() async {
    try {
      // Initialize Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in the 'patient_data' collection
      await firestore.collection('patient_data').add({
        'homePageData': homePageData,
        'generalHealthData': generalHealthData,
        'menstrualHistoryData': menstrualHistoryData,
        'pregnancyHistoryData': pregnancyHistoryData,
        'contraceptiveHistoryData': contraceptiveHistoryData,
        'fertilityTreatmentData': fertilityTreatmentData,
        'partnerHealthData': partnerHealthData,
        'familyHistoryData': familyHistoryData,
        'timestamp': FieldValue.serverTimestamp(), // Adds timestamp to the data
      });

      print("Data uploaded successfully!");
    } catch (e) {
      print("Error uploading data to Firebase: $e");
    }
  }
}
