import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class RoadmapScreen extends StatelessWidget {
  static const String routeName = '/roadmap';

  const RoadmapScreen({super.key});

  String _clean(String value) => value.trim().toLowerCase();

  int _semesterCount(String program) {
    final p = _clean(program);

    if (p.contains('mbbs')) return 10;
    if (p.contains('bds')) return 8;
    if (p.contains('pharm') || p.contains('pharmacy')) return 10;
    if (p.contains('dpt') || p.contains('physiotherapy')) return 10;
    if (p.contains('dvm') || p.contains('veterinary')) return 10;
    if (p.contains('architecture')) return 10;
    if (p.contains('llb') || p.contains('law')) return 10;
    if (p.contains('engineering')) return 8;
    if (p.contains('nursing')) return 8;
    if (p.contains('computer') ||
        p.contains('software') ||
        p.contains('data') ||
        p.contains('artificial') ||
        p.contains('cyber')) {
      return 8;
    }
    if (p.contains('bba') ||
        p.contains('business') ||
        p.contains('finance') ||
        p.contains('accounting')) {
      return 8;
    }

    return 8;
  }

  List<String> _semesterTasks(String program, int semester) {
    final p = _clean(program);

    if (p.contains('mbbs')) {
      return [
        'Study anatomy, physiology, and biochemistry concepts',
        'Build strong medical terminology and note-making habits',
        'Focus on practicals, viva preparation, and clinical basics',
        'Revise regularly and prepare for professional exams',
      ];
    }

    if (p.contains('software') || p.contains('computer')) {
      return [
        'Learn programming, problem solving, and database concepts',
        'Build mini projects and improve debugging skills',
        'Study software engineering, web/mobile development, and APIs',
        'Create portfolio projects and prepare for internships',
      ];
    }

    if (p.contains('artificial') || p.contains('data')) {
      return [
        'Strengthen Python, statistics, and data analysis basics',
        'Practice machine learning and visualization projects',
        'Work on real datasets and model evaluation',
        'Build AI portfolio and prepare final year project direction',
      ];
    }

    if (p.contains('engineering')) {
      return [
        'Build mathematics, physics, and engineering fundamentals',
        'Practice labs, drawings, tools, and technical reports',
        'Work on discipline-specific projects and software tools',
        'Prepare for internship, industry skills, and final project',
      ];
    }

    if (p.contains('bba') || p.contains('business') || p.contains('finance')) {
      return [
        'Study management, economics, accounting, and communication',
        'Practice presentations, reports, and case studies',
        'Build Excel, marketing, finance, and business analysis skills',
        'Prepare for internship, CV, and professional networking',
      ];
    }

    return [
      'Build strong basics of the selected field',
      'Improve communication, research, and practical skills',
      'Work on assignments, projects, and portfolio material',
      'Prepare for internships, final project, and future career',
    ];
  }

  List<String> _careerOutcomes(String program) {
    final p = _clean(program);

    if (p.contains('mbbs')) {
      return [
        'Doctor / Medical Officer',
        'Specialist after FCPS / Residency',
        'Medical Researcher',
        'Hospital or Healthcare Administrator',
      ];
    }

    if (p.contains('bds')) {
      return [
        'Dentist',
        'Dental Surgeon',
        'Orthodontics / Specialization Path',
        'Private Dental Clinic Owner',
      ];
    }

    if (p.contains('pharm') || p.contains('pharmacy')) {
      return [
        'Pharmacist',
        'Clinical Pharmacist',
        'Pharmaceutical Industry Officer',
        'Drug Inspector / Regulatory Roles',
      ];
    }

    if (p.contains('software') || p.contains('computer')) {
      return [
        'Software Engineer',
        'Web / Mobile App Developer',
        'Backend / Full Stack Developer',
        'Freelancer or Startup Founder',
      ];
    }

    if (p.contains('artificial')) {
      return [
        'AI Engineer',
        'Machine Learning Engineer',
        'AI Solution Developer',
        'Research Assistant in AI',
      ];
    }

    if (p.contains('data')) {
      return [
        'Data Analyst',
        'Data Scientist',
        'Business Intelligence Analyst',
        'Machine Learning Developer',
      ];
    }

    if (p.contains('engineering')) {
      return [
        'Field Engineer',
        'Design Engineer',
        'Project Engineer',
        'Technical Consultant',
      ];
    }

    if (p.contains('bba') || p.contains('business')) {
      return [
        'Business Manager',
        'Entrepreneur',
        'Marketing Executive',
        'Operations Manager',
      ];
    }

    if (p.contains('finance') || p.contains('accounting')) {
      return [
        'Finance Analyst',
        'Accountant',
        'Banking Officer',
        'Audit Associate',
      ];
    }

    return [
      'Professional Career in Selected Field',
      'Higher Studies Opportunity',
      'Government / Private Sector Jobs',
      'Freelancing or Entrepreneurship Path',
    ];
  }

  Future<void> _downloadPdf({
    required String program,
    required int totalSemesters,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(28),
        ),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.indigo,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Smart Career Navigator Roadmap',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Program: $program',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                  ),
                ),
                pw.Text(
                  'Total Semesters: $totalSemesters',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          ...List.generate(totalSemesters, (index) {
            final sem = index + 1;
            final tasks = _semesterTasks(program, sem);

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 14),
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.indigo,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      'Semester $sem',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...tasks.map(
                        (task) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('• '),
                          pw.Expanded(child: pw.Text(task)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          pw.SizedBox(height: 16),
          pw.Text(
            'Career Outcomes',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ..._careerOutcomes(program).map(
                (outcome) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.blue200),
              ),
              child: pw.Row(
                children: [
                  pw.Text('✓  '),
                  pw.Expanded(child: pw.Text(outcome)),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  Widget _semesterCard({
    required int semester,
    required List<String> tasks,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF38BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  '$semester',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Semester $semester',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...tasks.map(
                        (task) => Padding(
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
                              task,
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _careerOutcomeCard(String outcome) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA).withOpacity(0.22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.work_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                outcome,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final program = (args?['program'] ??
        args?['field'] ??
        args?['selectedField'] ??
        'Software Engineering')
        .toString();

    final totalSemesters = _semesterCount(program);
    final outcomes = _careerOutcomes(program);
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: const Text(
          'Career Roadmap',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
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
                              'Your Study Roadmap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$program • $totalSemesters semesters',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Semester Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 14),

                ...List.generate(totalSemesters, (index) {
                  final sem = index + 1;
                  return _semesterCard(
                    semester: sem,
                    tasks: _semesterTasks(program, sem),
                  );
                }),

                const SizedBox(height: 18),

                const Text(
                  'Career Outcomes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 14),

                ...outcomes.map(_careerOutcomeCard),

                const SizedBox(height: 26),

                ElevatedButton.icon(
                  onPressed: () => _downloadPdf(
                    program: program,
                    totalSemesters: totalSemesters,
                  ),
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