import 'package:flutter/material.dart';

import '../theme/scn_modern_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class SelectFieldScreen extends StatefulWidget {
  static const String routeName = '/select-field';

  const SelectFieldScreen({super.key});

  @override
  State<SelectFieldScreen> createState() => _SelectFieldScreenState();
}

class _SelectFieldScreenState extends State<SelectFieldScreen> {
  String educationLevel = 'Unknown';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      educationLevel = (args['educationLevel'] ?? 'Unknown').toString();
    }
  }

  List<Map<String, dynamic>> get fields {
    if (educationLevel == 'Matric') {
      return [
        {'name': 'Science', 'icon': Icons.science_rounded},
        {'name': 'Arts', 'icon': Icons.palette_rounded},
        {'name': 'Commerce', 'icon': Icons.business_center_rounded},
        {'name': 'Computer Science', 'icon': Icons.computer_rounded},
      ];
    }

    return [
      {'name': 'Medical', 'icon': Icons.medical_services_rounded},
      {'name': 'Engineering', 'icon': Icons.engineering_rounded},
      {'name': 'IT / Computer Science', 'icon': Icons.computer_rounded},
      {'name': 'Business', 'icon': Icons.business_rounded},
      {'name': 'Arts', 'icon': Icons.brush_rounded},
    ];
  }

  int _crossAxisCount(double width) {
    if (width >= 1100) return 4;
    if (width >= 750) return 3;
    return 2;
  }

  Widget _fieldCard(Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/student-details',
          arguments: {
            'educationLevel': educationLevel,
            'selectedField': item['name'],
          },
        );
      },
      child: GlassCard(
        child: Column(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF38BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item['icon'],
                color: Colors.white,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width >= 900 ? 1050.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: Text(
          '$educationLevel Fields',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF070018),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              children: [
                const Text(
                  'Choose Your Field',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  educationLevel == 'Matric'
                      ? 'Select the intermediate field you want to explore.'
                      : 'Select your current or interested field.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fields.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount(width),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) =>
                      _fieldCard(fields[index]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}