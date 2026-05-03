import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_service.dart';
import '../theme/scn_modern_theme.dart';

class HomeShellScreen extends StatefulWidget {
  static const String routeName = '/home-shell';

  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  bool showRobot = true;

  @override
  void initState() {
    super.initState();


  }

  Widget _robotImage({double height = 180}) {
    return SizedBox(
      height: 190,
      width: 300,
      child: Image.asset(
        'assets/images/ab1.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _sideItem(
      BuildContext context,
      IconData icon,
      String title,
      String route,
      bool active,
      ) {
    return InkWell(
      onTap: () {
        if (route == '/home-shell') return;
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.13) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: active ? Border.all(color: Colors.white24) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
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

  Widget _desktopSidebar(BuildContext context, String name) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF070018),
            Color(0xFF1B063A),
            Color(0xFF3B0A77),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          right: BorderSide(color: Color(0xFF4C1D95), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_rounded, color: Colors.white, size: 34),
              SizedBox(width: 10),
              Text(
                'SCN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Smart Career Navigator',
            style: TextStyle(
              color: Color(0xFFEDE9FE),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 35),
          _sideItem(context, Icons.dashboard_rounded, 'Dashboard', '/home-shell', true),
          _sideItem(context, Icons.person_outline_rounded, 'Profile', '/profile', false),
          _sideItem(context, Icons.explore_rounded, 'Career Discovery', '/select-level', false),
          _sideItem(context, Icons.chat_bubble_outline_rounded, 'AI Chat Advisor', '/chatbot', false),
          _sideItem(context, Icons.route_rounded, 'Roadmap', '/roadmap', false),
          _sideItem(context, Icons.history_rounded, 'History', '/history', false),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/select-level'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Start Guidance',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF7C3AED),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _careersForProfile(String field, String level) {
    final f = field.toLowerCase();

    if (f.contains('medical') || f.contains('pre-medical')) {
      return [
        {'title': 'MBBS / Doctor', 'match': '95%', 'icon': Icons.local_hospital_rounded, 'color': Colors.redAccent},
        {'title': 'BDS', 'match': '90%', 'icon': Icons.medical_services_rounded, 'color': Colors.pink},
        {'title': 'Pharm-D', 'match': '87%', 'icon': Icons.medication_rounded, 'color': Colors.green},
        {'title': 'Biotechnology', 'match': '82%', 'icon': Icons.biotech_rounded, 'color': SCNTheme.secondary},
      ];
    }

    if (f.contains('engineering') || f.contains('pre-engineering')) {
      return [
        {'title': 'Civil Engineering', 'match': '91%', 'icon': Icons.engineering_rounded, 'color': SCNTheme.primary},
        {'title': 'Electrical Engineering', 'match': '88%', 'icon': Icons.electrical_services_rounded, 'color': Colors.orange},
        {'title': 'Mechanical Engineering', 'match': '85%', 'icon': Icons.precision_manufacturing_rounded, 'color': Colors.blueGrey},
        {'title': 'Software Engineering', 'match': '82%', 'icon': Icons.code_rounded, 'color': SCNTheme.secondary},
      ];
    }

    if (f.contains('computer') || f.contains('it') || f.contains('ics')) {
      return [
        {'title': 'Software Engineer', 'match': '94%', 'icon': Icons.code_rounded, 'color': SCNTheme.primary},
        {'title': 'Data Scientist', 'match': '90%', 'icon': Icons.data_object_rounded, 'color': SCNTheme.secondary},
        {'title': 'AI Engineer', 'match': '88%', 'icon': Icons.psychology_rounded, 'color': Colors.deepPurple},
        {'title': 'Cyber Security', 'match': '84%', 'icon': Icons.security_rounded, 'color': Colors.green},
      ];
    }

    if (f.contains('business') || f.contains('icom') || f.contains('commerce')) {
      return [
        {'title': 'BBA', 'match': '91%', 'icon': Icons.business_rounded, 'color': SCNTheme.primary},
        {'title': 'Accounting & Finance', 'match': '88%', 'icon': Icons.account_balance_rounded, 'color': Colors.green},
        {'title': 'Marketing', 'match': '84%', 'icon': Icons.campaign_rounded, 'color': Colors.orange},
        {'title': 'Business Analyst', 'match': '82%', 'icon': Icons.analytics_rounded, 'color': SCNTheme.secondary},
      ];
    }

    if (f.contains('arts') || f.contains('fa')) {
      return [
        {'title': 'Psychology', 'match': '90%', 'icon': Icons.psychology_alt_rounded, 'color': SCNTheme.primary},
        {'title': 'Media Studies', 'match': '86%', 'icon': Icons.movie_creation_rounded, 'color': Colors.pink},
        {'title': 'Education', 'match': '84%', 'icon': Icons.school_rounded, 'color': Colors.green},
        {'title': 'English / Linguistics', 'match': '80%', 'icon': Icons.menu_book_rounded, 'color': SCNTheme.secondary},
      ];
    }

    return [
      {'title': 'Software Engineer', 'match': '92%', 'icon': Icons.code_rounded, 'color': SCNTheme.primary},
      {'title': 'Data Scientist', 'match': '88%', 'icon': Icons.data_object_rounded, 'color': SCNTheme.secondary},
      {'title': 'UI/UX Designer', 'match': '82%', 'icon': Icons.design_services_rounded, 'color': Colors.pink},
      {'title': 'Cyber Security', 'match': '82%', 'icon': Icons.security_rounded, 'color': Colors.green},
    ];
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, const Color(0xFF38BDF8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFEDE9FE),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _careerMiniCard(Map<String, dynamic> c) {
    final matchText = c['match'].toString().replaceAll('%', '');
    final matchValue = double.tryParse(matchText) ?? 80;
    final progress = (matchValue / 100).clamp(0.0, 1.0);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/roadmap',
          arguments: {'program': c['title'].toString()},
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0B35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        c['color'] as Color,
                        const Color(0xFF38BDF8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    c['icon'] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.favorite_border_rounded,
                  color: Color(0xFFD8B4FE),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              c['title'].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Explore roadmap and career path',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFFEDE9FE),
                fontSize: 12.5,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${c['match']} Match',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                color: const Color(0xFFC084FC),
                backgroundColor: const Color(0xFF2D164F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(
      BuildContext context,
      IconData icon,
      String title,
      String route,
      ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0B35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4C1D95), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFC084FC)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFD8B4FE),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardContent(BuildContext context, Map<String, dynamic> data) {
    final user = FirebaseAuth.instance.currentUser;
    final name = (data['name'] ?? user?.displayName ?? 'Student').toString();
    final level = (data['educationLevel'] ?? 'Not Set').toString();
    final field = (data['selectedField'] ?? 'Not Set').toString();
    final percentageRaw = data['percentage'];
    final percentage = percentageRaw == null ? '0' : percentageRaw.toString();

    final profileComplete =
        level != 'Not Set' &&
            field != 'Not Set' &&
            percentage != '0' &&
            percentage.trim().isNotEmpty;

    final careers = _careersForProfile(field, level);
    final isDesktop = MediaQuery.of(context).size.width >= 950;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF21105A),
            Color(0xFF4C1D95),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 26 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, $name 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 30 : 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Let’s discover the best career path for you.',
              style: TextStyle(
                color: Color(0xFFEDE9FE),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.15,
                          children: [
                            _statCard(
                              icon: Icons.school_rounded,
                              value: profileComplete ? '$percentage%' : '0%',
                              label: 'Your Best Fit',
                              color: const Color(0xFF9333EA),
                            ),
                            _statCard(
                              icon: Icons.explore_rounded,
                              value: profileComplete ? careers.length.toString() : '0',
                              label: 'Careers',
                              color: const Color(0xFF2563EB),
                            ),
                            _statCard(
                              icon: Icons.psychology_rounded,
                              value: level,
                              label: 'Education',
                              color: const Color(0xFFDB2777),
                            ),
                            _statCard(
                              icon: Icons.star_rounded,
                              value: field,
                              label: 'Selected Field',
                              color: const Color(0xFF7C3AED),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1B063A),
                                Color(0xFF3B0A77),
                                Color(0xFF7C3AED),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.28),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Discover. Learn.\nSucceed.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Answer a few questions, explore best career options and get a personalized roadmap.',
                                      style: TextStyle(
                                        color: Color(0xFFEDE9FE),
                                        fontSize: 15,
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/select-level');
                                      },
                                      icon: const Icon(Icons.arrow_forward_rounded),
                                      label: const Text('Continue Assessment'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFA855F7),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                height: 190,
                                width: 230,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.purpleAccent.withOpacity(0.45),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Center(child: _robotImage(height: 160)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Top Career Recommendations',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  profileComplete ? '/suggestions' : '/select-level',
                                  arguments: profileComplete
                                      ? {
                                    'educationLevel': level,
                                    'selectedField': field,
                                    'percentage': percentage,
                                  }
                                      : null,
                                );
                              },
                              child: Text(
                                profileComplete ? 'View All' : 'Complete Profile',
                                style: const TextStyle(color: Color(0xFFC084FC)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        if (!profileComplete)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A0B35),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.assignment_rounded, size: 56, color: Color(0xFFC084FC)),
                                const SizedBox(height: 12),
                                const Text(
                                  'Complete your profile to see personalized recommendations',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/select-level'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFA855F7),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Complete Profile'),
                                ),
                              ],
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: careers.length > 3 ? 3 : careers.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.20,
                            ),
                            itemBuilder: (context, index) {
                              final c = careers[index];
                              return _careerMiniCard(c);
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A0B35),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Meet SCN AI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.4),
                                      blurRadius: 40,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/ab2.png',
                                  height: 180,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'Hi! I’m your AI career assistant.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ask me anything about careers, skills, or your future.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFEDE9FE),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/chatbot');
                                  },
                                  icon: const Icon(Icons.chat_rounded),
                                  label: const Text('Chat with SCN AI'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9333EA),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A0B35),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quick Actions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _quickAction(context, Icons.quiz_rounded, 'Take Skill Quiz', '/quiz'),
                              _quickAction(context, Icons.explore_rounded, 'Explore Careers', '/select-level'),
                              _quickAction(context, Icons.route_rounded, 'Career Roadmap', '/roadmap'),
                              _quickAction(context, Icons.favorite_rounded, 'Saved Careers', '/history'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      _statCard(icon: Icons.school_rounded, value: profileComplete ? '$percentage%' : '0%', label: 'Best Fit', color: const Color(0xFF9333EA)),
                      _statCard(icon: Icons.work_rounded, value: profileComplete ? careers.length.toString() : '0', label: 'Careers', color: const Color(0xFF2563EB)),
                      _statCard(icon: Icons.psychology_rounded, value: level, label: 'Education', color: const Color(0xFFDB2777)),
                      _statCard(icon: Icons.star_rounded, value: field, label: 'Field', color: const Color(0xFF7C3AED)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1B063A),
                          Color(0xFF7C3AED),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/ab1.png',
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Discover. Learn. Succeed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Explore best career options and get a personalized roadmap.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFEDE9FE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/select-level'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA855F7),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Continue Assessment'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Top Career Recommendations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            profileComplete ? '/suggestions' : '/select-level',
                            arguments: profileComplete
                                ? {
                              'educationLevel': level,
                              'selectedField': field,
                              'percentage': percentage,
                            }
                                : null,
                          );
                        },
                        child: Text(
                          profileComplete ? 'View All' : 'Complete',
                          style: const TextStyle(color: Color(0xFFC084FC)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!profileComplete)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A0B35),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.assignment_rounded, size: 50, color: Color(0xFFC084FC)),
                          const SizedBox(height: 12),
                          const Text(
                            'Complete your profile to see personalized recommendations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/select-level'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA855F7),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Complete Profile'),
                          ),
                        ],
                      ),
                    )
                  else
                    ...careers.take(3).map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _careerMiniCard(c),
                      );
                    }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _robotWelcomeOverlay() {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        opacity: showRobot ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          color: Colors.black.withOpacity(0.12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              margin: EdgeInsets.only(left: showRobot ? 300 : -420),
              width: 420,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0B35),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF4C1D95), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _robotImage(height: 90),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Welcome to the\nSmart Career Navigator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 950;

    return StreamBuilder<Map<String, dynamic>?>(
      stream: FirestoreService.instance.getUserProfileStream(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};
        final user = FirebaseAuth.instance.currentUser;
        final name = (data['name'] ?? user?.displayName ?? 'Student').toString();

        return Scaffold(
          backgroundColor: const Color(0xFF070018),
          appBar: isDesktop
              ? null
              : AppBar(
            backgroundColor: const Color(0xFF070018),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'SCN Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          drawer: isDesktop
              ? null
              : Drawer(
            width: 280,
            child: _desktopSidebar(context, name),
          ),
          body: Stack(
            children: [
              isDesktop
                  ? Row(
                children: [
                  _desktopSidebar(context, name),
                  Expanded(child: _dashboardContent(context, data)),
                ],
              )
                  : _dashboardContent(context, data),
             // if (showRobot) _robotWelcomeOverlay(),
            ],
          ),
        );
      },
    );
  }
}
