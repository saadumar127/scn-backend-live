// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
//import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../services/ai_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class RoadmapScreen extends StatefulWidget {
  static const String routeName = '/roadmap';

  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  bool isLoading = true;
  String? errorMessage;

  String program = 'Software Engineering';
  String field = 'General';
  String educationLevel = 'Unknown';
  String roadmapText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    program = (args?['chosenPath'] ??
        args?['program'] ??
        args?['field'] ??
        args?['selectedField'] ??
        'Software Engineering')
        .toString();

    field = (args?['field'] ?? args?['selectedField'] ?? program).toString();
    educationLevel = (args?['educationLevel'] ?? 'Unknown').toString();

    if (roadmapText.isEmpty && isLoading) {
      _loadRoadmap();
    }
  }

  Future<void> _loadRoadmap() async {
    try {
      final result = await AiService.instance.generateRoadmap(
        chosenPath: program,
        field: field,
        educationLevel: educationLevel,
      );

      if (!mounted) return;

      setState(() {
        roadmapText = result.trim().isEmpty
            ? 'No roadmap generated. Please try again.'
            : result.trim();
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _parseRoadmap(String text) {
    final sections = <Map<String, dynamic>>[];

    final regex = RegExp(
      r'(SEMESTER\s+\d+:|BRIDGE REQUIREMENT:|CAREER OUTCOMES:|NEXT STEP:)',
      caseSensitive: false,
    );

    final matches = regex.allMatches(text).toList();

    for (int i = 0; i < matches.length; i++) {
      final end = i + 1 < matches.length ? matches[i + 1].start : text.length;

      final title = matches[i].group(0)!.trim();
      final content = text
          .substring(matches[i].end, end)
          .trim()
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      sections.add({
        'title': title,
        'items': content,
      });
    }

    return sections;
  }

  List<String> _splitItems(String text) {
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String _cleanFileName(String value) {
    return value
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(' ', '_')
        .trim();
  }

  Future<void> _downloadPdf() async {
    try {
      final doc = pw.Document();
      final sections = _parseRoadmap(roadmapText);

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(28),
          build: (context) => [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.deepPurple,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Smart Career Navigator Roadmap',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text('Program: $program',
                      style: const pw.TextStyle(color: PdfColors.white)),
                  pw.Text('Education Level: $educationLevel',
                      style: const pw.TextStyle(color: PdfColors.white)),
                ],
              ),
            ),
            pw.SizedBox(height: 18),

            if (sections.isEmpty)
              ...roadmapText.split('\n').map(
                    (line) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text(line,
                      style: const pw.TextStyle(fontSize: 11)),
                ),
              )
            else
              ...sections.map((section) {
                final title = section['title'].toString();
                final items = List<String>.from(section['items'] as List);

                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 14),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(title.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.deepPurple,
                          )),
                      pw.SizedBox(height: 8),

                      ...items.expand((item) {
                        final clean = item.replaceAll('-', '').trim();

                        if (!clean.contains(':')) {
                          return [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 5),
                              child: pw.Text('• $clean',
                                  style: const pw.TextStyle(fontSize: 11)),
                            ),
                          ];
                        }

                        final parts = clean.split(':');
                        final heading = parts.first.trim();
                        final subItems =
                        _splitItems(parts.sublist(1).join(':'));

                        return [
                          pw.Padding(
                            padding:
                            const pw.EdgeInsets.only(top: 6, bottom: 4),
                            child: pw.Text('$heading:',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue,
                                )),
                          ),
                          ...subItems.map(
                                (sub) => pw.Padding(
                              padding:
                              const pw.EdgeInsets.only(bottom: 4),
                              child: pw.Text('• $sub',
                                  style: const pw.TextStyle(fontSize: 11)),
                            ),
                          ),
                        ];
                      }),
                    ],
                  ),
                );
              }),
          ],
        ),
      );

      final bytes = await doc.save();

      final fileName =
          'SCN_Roadmap_${program.replaceAll(' ', '_').replaceAll('/', '_')}.pdf';

      // ✅ ANDROID SAVE + OPEN
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(bytes);

      await OpenFilex.open(file.path);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF saved & opened')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF failed: $e')),
      );
    }
  }
  Widget _loadingScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC084FC),
          ),
        ),
      ),
    );
  }

  Widget _errorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFFCA5A5),
                    size: 54,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Roadmap Not Loaded',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    errorMessage ?? 'Unknown error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFEDE9FE),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      _loadRoadmap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roadmapItem(String item) {
    final text = item.replaceAll('-', '').trim();

    if (!text.contains(':')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF22C55E),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFFEDE9FE),
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final parts = text.split(':');
    final heading = parts.first.trim();
    final rawValue = parts.sublist(1).join(':').trim();

    final subItems = rawValue
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toUpperCase() == 'SUBJECTS' ? 'Main Subjects:' : '$heading:',
            style: const TextStyle(
              color: Color(0xFF38BDF8),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),

          ...subItems.map((sub) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF22C55E),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sub,
                      style: const TextStyle(
                        color: Color(0xFFEDE9FE),
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionCard(Map<String, dynamic> section) {
    final title = section['title'].toString();
    final items = List<String>.from(section['items'] as List);

    final upperTitle = title.toUpperCase();
    final isSpecial = upperTitle.contains('BRIDGE') ||
        upperTitle.contains('CAREER') ||
        upperTitle.contains('NEXT');

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSpecial ? const Color(0xFF2D164F) : const Color(0xFF16002F),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
            isSpecial ? const Color(0xFFC084FC) : const Color(0xFF4C1D95),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              upperTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map(_roadmapItem),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _loadingScreen();
    if (errorMessage != null) return _errorScreen();

    final isDesktop = MediaQuery.of(context).size.width >= 850;
    final sections = _parseRoadmap(roadmapText);

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: const Text(
          'Career Roadmap',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: const Color(0xFF070018),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 980 : double.infinity,
            ),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2D006B),
                        Color(0xFF7C3AED),
                        Color(0xFF38BDF8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.30),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.route_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your AI Study Roadmap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$program • $educationLevel',
                              style: const TextStyle(
                                color: Color(0xFFEDE9FE),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'AI Generated Roadmap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (sections.isEmpty)
                        Text(
                          roadmapText,
                          style: const TextStyle(
                            color: Color(0xFFEDE9FE),
                            fontSize: 15,
                            height: 1.55,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        ...sections.map(_sectionCard),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton.icon(
                  onPressed: _downloadPdf,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Roadmap PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9333EA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}