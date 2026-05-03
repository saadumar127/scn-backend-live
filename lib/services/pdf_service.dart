import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'roadmap_data_service.dart';

class PdfService {
  static Future<void> generateRoadmapPdf({
    required String program,
  }) async {
    final roadmap = RoadmapDataService.getRoadmap(program);
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(22),
            decoration: pw.BoxDecoration(
              gradient: const pw.LinearGradient(
                colors: [
                  PdfColor.fromInt(0xFF6C63FF),
                  PdfColor.fromInt(0xFF63A4FF),
                ],
              ),
              borderRadius: pw.BorderRadius.circular(18),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Smart Career Navigator Roadmap',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  program,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  roadmap.overview,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            'Semester-wise Roadmap',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF2F2A5A),
            ),
          ),
          pw.SizedBox(height: 12),

          ...roadmap.semesters.asMap().entries.map((entry) {
            final semesterNumber = entry.key + 1;
            final items = entry.value;

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 14),
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF7F7FB),
                border: pw.Border.all(color: PdfColor.fromInt(0xFFE1E1EA)),
                borderRadius: pw.BorderRadius.circular(14),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF6C63FF),
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Text(
                      'Semester $semesterNumber',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...items.map(
                        (item) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Bullet(
                        text: item,
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          pw.SizedBox(height: 8),
          pw.Text(
            'Career Outcomes',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF2F2A5A),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF7F7FB),
              border: pw.Border.all(color: PdfColor.fromInt(0xFFE1E1EA)),
              borderRadius: pw.BorderRadius.circular(14),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: roadmap.careers
                  .map(
                    (career) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Bullet(
                    text: career,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              )
                  .toList(),
            ),
          ),

          pw.SizedBox(height: 14),
          pw.Text(
            'Recommended Certifications / Growth Areas',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFF2F2A5A),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF7F7FB),
              border: pw.Border.all(color: PdfColor.fromInt(0xFFE1E1EA)),
              borderRadius: pw.BorderRadius.circular(14),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: roadmap.certifications
                  .map(
                    (cert) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Bullet(
                    text: cert,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '${program}_Roadmap.pdf',
    );
  }
}