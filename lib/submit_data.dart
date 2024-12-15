import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SubmitData {
  // Method to convert JSON data to a PDF file with tables and pagination
  Future<void> convertJsonToPdf(Map<String, dynamic> jsonData, List<File> images) async {
    try {
      // Create a new PDF document
      final pdf = pw.Document();

      // Add content to the PDF document
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              buildSectionTable('Personal Details', [
                ['Field', 'Value'],
                ['Name', jsonData['home_page_data']['name'] ?? ''],
                ['Age', jsonData['home_page_data']['age'] ?? ''],
                ['Hobby', jsonData['home_page_data']['hobby'] ?? ''],
                ['Profession', jsonData['home_page_data']['profession'] ?? ''],
              ]),
              pw.SizedBox(height: 10),

              buildSectionTable('Menstrual History', [
                ['Field', 'Value'],
                ['Age at First Period', jsonData['menstrual_history']['age_at_first_period'] ?? ''],
                ['Last Period Date', jsonData['menstrual_history']['last_period_date'] ?? ''],
                ['Is Period Normal', jsonData['menstrual_history']['is_period_normal'].toString()],
                ['Are Periods Regular', jsonData['menstrual_history']['are_periods_regular'].toString()],
                ['Period Gap', jsonData['menstrual_history']['period_gap'] ?? ''],
                ['Cramp Severity', jsonData['menstrual_history']['cramp_severity'] ?? ''],
                ['Has Cramps', jsonData['menstrual_history']['has_cramps'].toString()],
                ['Cramp Medication', jsonData['menstrual_history']['cramp_medication'] ?? ''],
                ['Spotting', jsonData['menstrual_history']['spotting'].toString()],
              ]),
              pw.SizedBox(height: 10),

              buildSectionTable('Pregnancy History', [
                ['Field', 'Value'],
                ['Had Term Pregnancies', jsonData['pregnancy_history']['had_term_pregnancies'].toString()],
                ['Term Pregnancies Count', jsonData['pregnancy_history']['term_pregnancies_count']?.toString() ?? ''],
                ['Had Preterm Pregnancies', jsonData['pregnancy_history']['had_preterm_pregnancies'].toString()],
                ['Preterm Health Details', jsonData['pregnancy_history']['preterm_health_details'] ?? ''],
                ['Had Natural Abortions', jsonData['pregnancy_history']['had_natural_abortions'].toString()],
                ['Natural Abortions Count', jsonData['pregnancy_history']['natural_abortions_count']?.toString() ?? ''],
                ['Had Medical Abortions', jsonData['pregnancy_history']['had_medical_abortions'].toString()],
                ['Medical Abortions Count', jsonData['pregnancy_history']['medical_abortions_count']?.toString() ?? ''],
                ['Had Ectopic Pregnancies', jsonData['pregnancy_history']['had_ectopic_pregnancies'].toString()],
                ['Ectopic Pregnancies Count', jsonData['pregnancy_history']['ectopic_pregnancies_count']?.toString() ?? ''],
              ]),
              pw.SizedBox(height: 10),

              buildSectionTable('Contraceptive & Sexual History', [
                ['Field', 'Value'],
                ['Methods Used', jsonData['contraceptive_sexual_history']['methods_used'].toString()],
                ['Periods Regular After Pills', jsonData['contraceptive_sexual_history']['periods_regular_after_pills'].toString()],
                ['Timing Intercourse Around Ovulation', jsonData['contraceptive_sexual_history']['timing_intercourse_around_ovulation'].toString()],
                ['Ovulation Timing Details', jsonData['contraceptive_sexual_history']['ovulation_timing_details'] ?? ''],
              ]),
              pw.SizedBox(height: 10),

              buildSectionTable('Fertility History', [
                ['Field', 'Value'],
                ['Treated for Infertility', jsonData['fertility_history']['treated_for_infertility'].toString()],
                ['Physician', jsonData['fertility_history']['physician'] ?? ''],
                ['Diagnosed Cause', jsonData['fertility_history']['diagnosed_cause'] ?? ''],
                ['IUI Cycles', jsonData['fertility_history']['iui_cycles'] ?? ''],
                ['IUI Dates', jsonData['fertility_history']['iui_dates'] ?? ''],
                ['Clomid Alone Cycles', jsonData['fertility_history']['clomid_alone_cycles'] ?? ''],
                ['Clomid Alone Dates', jsonData['fertility_history']['clomid_alone_dates'] ?? ''],
                ['Clomid with IUI Cycles', jsonData['fertility_history']['clomid_with_iui_cycles'] ?? ''],
                ['Clomid with IUI Dates', jsonData['fertility_history']['clomid_with_iui_dates'] ?? ''],
                ['HCG Injections Cycles', jsonData['fertility_history']['hcg_injections_cycles'] ?? ''],
                ['HCG Injections Dates', jsonData['fertility_history']['hcg_injections_dates'] ?? ''],
                ['IVF Cycles', jsonData['fertility_history']['ivf_cycles'] ?? ''],
                ['IVF Cycles Dates', jsonData['fertility_history']['ivf_cycles_dates'] ?? ''],
                ['Frozen Embryo Cycles', jsonData['fertility_history']['frozen_embryo_cycles'] ?? ''],
                ['Frozen Embryo Dates', jsonData['fertility_history']['frozen_embryo_dates'] ?? ''],
                ['Canceled IVF Attempts', jsonData['fertility_history']['canceled_ivf_attempts'] ?? ''],
              ]),
              pw.SizedBox(height: 10),
            ];
          },
        ),
      );
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              buildSectionTable('Partner Health History', [
                ['Field', 'Value'],
                ['Semen Analysis Done', jsonData['partner_health_history']['semen_analysis_done'].toString()],
                ['Semen Analysis Normal', jsonData['partner_health_history']['semen_analysis_normal'].toString()],
                ['Sperm Count', jsonData['partner_health_history']['sperm_count'] ?? ''],
                ['Sperm Motility', jsonData['partner_health_history']['sperm_motility'] ?? ''],
                ['TZI Levels', jsonData['partner_health_history']['tzi_levels'] ?? ''],
                ['UTI Test', jsonData['partner_health_history']['uti_test'] ?? ''],
                ['White Blood Cells', jsonData['partner_health_history']['white_blood_cells'] ?? ''],
                ['Partner Seeing Doctor', jsonData['partner_health_history']['partner_seeing_doctor'].toString()],
                ['Diagnosis', jsonData['partner_health_history']['diagnosis'] ?? ''],
                ['Fathered Child', jsonData['partner_health_history']['fathered_child'].toString()],
                ['Fathered Child Date', jsonData['partner_health_history']['fathered_child_date'] ?? ''],
                ['Diagnosed with Conditions', jsonData['partner_health_history']['diagnosed_with_conditions'].toString()],
                ['Condition Details', jsonData['partner_health_history']['condition_details'] ?? ''],
                ['Prescribed Drugs', jsonData['partner_health_history']['prescribed_drugs'] ?? ''],
              ]),
              pw.SizedBox(height: 10),
            ];
          },
        ),
      );
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              buildSectionTable('Family History', [
                ['Field', 'Value'],
                ['Mother Had Issues', jsonData['family_history']['mother_had_issues'].toString()],
                ['Mother Issues Details', jsonData['family_history']['mother_issues_details'] ?? ''],
                ['Family History Infertility', jsonData['family_history']['family_history_infertility'].toString()],
                ['Family Infertility Details', jsonData['family_history']['family_infertility_details'] ?? ''],
                ['Bleeding Tendencies', jsonData['family_history']['bleeding_tendencies'].toString()],
                ['Strokes', jsonData['family_history']['strokes'].toString()],
                ['Cancer', jsonData['family_history']['cancer'].toString()],
                ['Thyroid Disorders', jsonData['family_history']['thyroid_disorders'].toString()],
                ['Diabetes', jsonData['family_history']['diabetes'].toString()],
                ['Tuberculosis', jsonData['family_history']['tuberculosis'].toString()],
                ['HPV', jsonData['family_history']['hpv'].toString()],
                ['HCV', jsonData['family_history']['hcv'].toString()],
                ['HIV', jsonData['family_history']['hiv'].toString()],
                ['Heart Disease', jsonData['family_history']['heart_disease'].toString()],
                ['High Blood Pressure', jsonData['family_history']['high_blood_pressure'].toString()],
                ['Other Conditions', jsonData['family_history']['other_conditions'] ?? ''],
              ]),
              pw.SizedBox(height: 10),
              ...images.map((image) {
                final imageBytes = image.readAsBytesSync();
                final pdfImage = pw.MemoryImage(imageBytes);
                return pw.Image(pdfImage); // PDF-specific widget
              }).toList(),


              pw.SizedBox(height: 10),
            ];
          },
        ),
      );

      final directory = Directory('/storage/emulated/0/Download');
      final filePath = '${directory.path}/Patient Data.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print('PDF created at $filePath');
    } catch (e) {
      print('Error: $e');
    }
  }

  pw.Widget buildSectionTable(String title, List<List<String>> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        pw.Table.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.black, width: 1),
          headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 12),
          data: data,
        ),
      ],
    );
  }
}
