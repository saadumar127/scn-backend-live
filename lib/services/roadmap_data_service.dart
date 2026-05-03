class RoadmapModel {
  final String overview;
  final List<List<String>> semesters;
  final List<String> careers;
  final List<String> certifications;

  const RoadmapModel({
    required this.overview,
    required this.semesters,
    required this.careers,
    required this.certifications,
  });
}

class RoadmapDataService {
  static String normalizeField(String field) {
    final value = field.trim().toLowerCase();

    const mapping = {
      'se': 'Software Engineering',
      'software engg': 'Software Engineering',
      'software engineering': 'Software Engineering',
      'cs': 'Computer Science',
      'computer science': 'Computer Science',
      'ai': 'Artificial Intelligence',
      'artificial intelligence': 'Artificial Intelligence',
      'ds': 'Data Science',
      'data science': 'Data Science',
      'cyber security': 'Cyber Security',
      'cybersecurity': 'Cyber Security',
      'it': 'Information Technology',
      'information technology': 'Information Technology',
      'pre medical': 'Pre-Medical',
      'pre-medical': 'Pre-Medical',
      'pre engineering': 'Pre-Engineering',
      'pre-engineering': 'Pre-Engineering',
      'icom': 'ICOM',
      'ics': 'ICS',
      'fa': 'FA',
      'bba': 'BBA',
      'finance': 'Finance',
      'banking': 'Banking',
      'marketing': 'Marketing',
      'hrm': 'Human Resource Management',
      'mbbs': 'MBBS',
      'bds': 'BDS',
      'pharm d': 'Pharm-D',
      'pharm-d': 'Pharm-D',
      'dpt': 'DPT',
      'civil engineering': 'Civil Engineering',
      'electrical engineering': 'Electrical Engineering',
      'mechanical engineering': 'Mechanical Engineering',
      'architecture': 'Architecture',
      'interior design': 'Interior Design',
      'psychology': 'Psychology',
      'english': 'English',
      'english literature': 'English Literature',
      'english language': 'English Language',
      'media studies': 'Media Studies',
      'media sciences': 'Media Sciences',
      'international relations': 'International Relations',
      'political science': 'Political Science',
      'public administration': 'Public Administration',
      'education': 'Education',
      'education leadership': 'Education Leadership',
      'commerce': 'Commerce',
      'general science': 'General Science',
      'biotechnology': 'Biotechnology',
      'business analytics': 'Business Analytics',
      'international business': 'International Business',
      'accounting and finance': 'Accounting and Finance',
    };

    return mapping[value] ?? field.trim();
  }

  static RoadmapModel getRoadmap(String field) {
    final normalizedField = normalizeField(field);

    final map = <String, RoadmapModel>{
      'Pre-Medical': const RoadmapModel(
        overview:
        'Pre-Medical students can move toward medical and health sciences fields, and with the right requirements can also explore selected alternative paths.',
        semesters: [
          [
            'Build strong biology foundations',
            'Improve chemistry concepts',
            'Develop disciplined study habits',
            'Focus on board exam strategy',
          ],
          [
            'Strengthen medical subject understanding',
            'Practice analytical thinking',
            'Improve time management',
            'Prepare for entry test direction',
          ],
          [
            'Explore MBBS, BDS, Pharm-D, DPT and Biotechnology options',
            'Understand merit requirements',
            'Build communication confidence',
            'Start career planning seriously',
          ],
          [
            'Prepare admission path and future specialization direction',
            'Strengthen weak topics',
            'Improve interview and confidence',
            'Plan next academic transition',
          ],
        ],
        careers: [
          'MBBS',
          'BDS',
          'Pharm-D',
          'DPT',
          'Biotechnology',
        ],
        certifications: [
          'Entry test preparation',
          'Communication skills',
          'Study skills workshops',
        ],
      ),
      'Pre-Engineering': const RoadmapModel(
        overview:
        'Pre-Engineering students can pursue multiple engineering, computing, and technical university paths depending on interest and eligibility.',
        semesters: [
          [
            'Strengthen mathematics fundamentals',
            'Improve physics concepts',
            'Build disciplined routine',
            'Focus on problem solving',
          ],
          [
            'Develop technical confidence',
            'Improve chemistry understanding',
            'Practice numerical problem solving',
            'Prepare for board performance',
          ],
          [
            'Explore engineering and computing options',
            'Understand merit and admission conditions',
            'Build communication and confidence',
            'Plan technical direction',
          ],
          [
            'Prepare for university admissions',
            'Strengthen weak concepts',
            'Improve test readiness',
            'Finalize career direction',
          ],
        ],
        careers: [
          'Civil Engineering',
          'Electrical Engineering',
          'Mechanical Engineering',
          'Software Engineering',
          'Architecture',
        ],
        certifications: [
          'Entry test preparation',
          'Technical communication',
          'Problem solving practice',
        ],
      ),
      'ICS': const RoadmapModel(
        overview:
        'ICS is a strong path toward computing, software, AI, security, and data-related fields.',
        semesters: [
          [
            'Build programming basics',
            'Strengthen mathematics',
            'Develop logical thinking',
            'Improve study discipline',
          ],
          [
            'Practice coding regularly',
            'Improve database and computer concepts',
            'Strengthen problem solving',
            'Build confidence in technical work',
          ],
          [
            'Explore software, AI, data and security paths',
            'Build mini projects',
            'Understand admission and merit trends',
            'Start profile building',
          ],
          [
            'Prepare for university transition',
            'Strengthen coding and interview basics',
            'Improve communication',
            'Finalize computing direction',
          ],
        ],
        careers: [
          'Software Engineering',
          'Computer Science',
          'Artificial Intelligence',
          'Data Science',
          'Cyber Security',
        ],
        certifications: [
          'Programming basics',
          'Git/GitHub',
          'Problem solving practice',
        ],
      ),
      'ICOM': const RoadmapModel(
        overview:
        'ICOM students can move into business, management, banking, economics, marketing, and finance-related fields.',
        semesters: [
          [
            'Strengthen accounting basics',
            'Improve business understanding',
            'Develop communication confidence',
            'Build study discipline',
          ],
          [
            'Practice numerical accuracy',
            'Understand commerce subjects clearly',
            'Improve presentation skills',
            'Prepare for transition to university business studies',
          ],
          [
            'Explore BBA, Finance, Banking, Economics and Marketing paths',
            'Understand eligibility and merit',
            'Build confidence in business communication',
            'Start long-term planning',
          ],
          [
            'Prepare for admissions',
            'Strengthen weak areas',
            'Improve professional image',
            'Finalize future business direction',
          ],
        ],
        careers: [
          'BBA',
          'Accounting and Finance',
          'Marketing',
          'Economics',
          'Banking',
        ],
        certifications: [
          'Excel basics',
          'Communication skills',
          'Business writing basics',
        ],
      ),
      'FA': const RoadmapModel(
        overview:
        'FA students can pursue social sciences, humanities, media, education, psychology, and related academic paths.',
        semesters: [
          [
            'Build strong reading and writing habits',
            'Develop communication confidence',
            'Improve discipline and consistency',
            'Understand humanities basics',
          ],
          [
            'Strengthen subject clarity',
            'Improve presentation and expression',
            'Develop analytical thinking',
            'Build confidence in academic work',
          ],
          [
            'Explore psychology, English, media, IR and education fields',
            'Understand eligibility and merit',
            'Improve career awareness',
            'Start profile building',
          ],
          [
            'Prepare for university transition',
            'Strengthen weak areas',
            'Improve confidence and communication',
            'Finalize academic direction',
          ],
        ],
        careers: [
          'Psychology',
          'English',
          'Media Studies',
          'International Relations',
          'Education',
        ],
        certifications: [
          'Communication skills',
          'Presentation practice',
          'Academic writing basics',
        ],
      ),
      'MBBS': const RoadmapModel(
        overview:
        'MBBS is a professional medical degree that requires long-term discipline, strong theoretical understanding, and clinical readiness.',
        semesters: [
          ['Build anatomy and physiology basics', 'Develop strong study habits', 'Improve note making and revision routine', 'Strengthen discipline and time management'],
          ['Study anatomy in depth', 'Improve physiology concepts', 'Focus on practical understanding', 'Prepare for viva and internal assessments'],
          ['Study biochemistry concepts', 'Improve medical terminology understanding', 'Build confidence in theoretical subjects', 'Practice concept linking between subjects'],
          ['Strengthen pathology basics', 'Understand disease mechanisms', 'Improve practical and lab confidence', 'Develop better academic consistency'],
          ['Study pharmacology and disease concepts', 'Understand how treatments work', 'Connect theory with patient conditions', 'Improve revision quality'],
          ['Focus on forensic and community medicine', 'Improve case understanding', 'Develop presentation skills', 'Strengthen communication in academic settings'],
          ['Start stronger clinical exposure', 'Observe hospital-based learning carefully', 'Improve professional behavior', 'Build confidence in patient-related learning'],
          ['Strengthen medicine and surgery concepts', 'Improve history taking basics', 'Practice clinical reasoning', 'Develop practical discipline'],
          ['Focus on rotations and ward learning', 'Improve interaction with patients', 'Prepare for real clinical responsibilities', 'Strengthen case discussion skills'],
          ['Prepare for final professional transition', 'Strengthen clinical decision basics', 'Improve confidence for house job pathway', 'Plan specialization direction'],
        ],
        careers: ['Doctor', 'Medical Officer', 'House Job Pathway', 'Residency / Specialization Pathway'],
        certifications: ['Clinical communication', 'Emergency care workshops', 'Research basics', 'Medical seminars and conferences'],
      ),
      'BDS': const RoadmapModel(
        overview:
        'BDS is a professional dental degree focused on oral health, dental sciences, patient care, and practical clinical work.',
        semesters: [
          ['Build basics of anatomy and oral biology', 'Develop discipline and study routine', 'Improve note making skills', 'Strengthen communication confidence'],
          ['Study physiology and dental foundations', 'Improve practical preparation', 'Focus on consistency in theory and viva', 'Build exam confidence'],
          ['Study pathology and oral sciences', 'Improve lab and class performance', 'Connect theory with practice', 'Develop professional behavior'],
          ['Strengthen pharmacology and dental sciences', 'Improve concept clarity', 'Work on practical precision', 'Build communication with confidence'],
          ['Begin pre-clinical dental work', 'Develop hand skills and accuracy', 'Understand dental materials', 'Improve attention to detail'],
          ['Move toward clinical work', 'Improve diagnosis basics', 'Build patient interaction confidence', 'Strengthen treatment understanding'],
          ['Strengthen restorative and operative learning', 'Improve practical case handling', 'Build treatment planning awareness', 'Prepare for final professional practice'],
          ['Refine clinical confidence', 'Improve professional ethics and presentation', 'Prepare for dental practice transition', 'Plan future specialization or practice path'],
        ],
        careers: ['Dentist', 'Dental Surgeon', 'Clinical Dental Practice'],
        certifications: ['Dental workshops', 'Clinical documentation', 'Patient communication'],
      ),
      'Pharm-D': const RoadmapModel(
        overview:
        'Pharm-D is a pharmacy degree focused on medicines, pharmacology, patient counseling, and healthcare systems.',
        semesters: [
          ['Strengthen chemistry and biology basics', 'Develop study discipline', 'Understand drug fundamentals', 'Improve communication'],
          ['Study pharmaceutical chemistry', 'Focus on note quality and organization', 'Improve practical work', 'Build academic consistency'],
          ['Strengthen pharmacology basics', 'Learn formulation concepts', 'Improve lab confidence', 'Develop professional habits'],
          ['Study medicinal chemistry', 'Connect theory with medicine action', 'Improve concept clarity', 'Build presentation skills'],
          ['Understand clinical pharmacy basics', 'Improve patient counseling mindset', 'Build healthcare understanding', 'Strengthen class performance'],
          ['Focus on therapeutics and patient support', 'Improve communication in health settings', 'Understand prescriptions better', 'Develop confidence in practical learning'],
          ['Learn hospital pharmacy concepts', 'Improve documentation skills', 'Prepare for internships', 'Strengthen professional profile'],
          ['Study advanced clinical and therapeutic topics', 'Build career clarity', 'Improve applied pharmaceutical knowledge', 'Prepare for future specialization'],
          ['Project and research orientation', 'Build CV and profile', 'Prepare for interviews', 'Explore industry opportunities'],
          ['Finalize professional readiness', 'Improve field confidence', 'Plan licensing/career direction', 'Prepare for healthcare and industry roles'],
        ],
        careers: ['Pharmacist', 'Clinical Pharmacist', 'Drug Safety Associate', 'Medical Representative'],
        certifications: ['Drug safety basics', 'Clinical pharmacy workshops', 'Healthcare communication'],
      ),
      'DPT': const RoadmapModel(
        overview:
        'DPT focuses on rehabilitation, movement science, therapy planning, and patient recovery.',
        semesters: [
          ['Build body systems basics', 'Develop strong study routine', 'Improve communication and confidence', 'Understand field foundations'],
          ['Study anatomy and physiology in depth', 'Improve practical preparation', 'Strengthen note quality', 'Prepare for viva and practicals'],
          ['Learn movement science basics', 'Improve patient-care mindset', 'Build better class consistency', 'Strengthen theoretical understanding'],
          ['Study therapeutic techniques', 'Improve practical discipline', 'Develop presentation confidence', 'Understand rehabilitation basics'],
          ['Strengthen clinical therapy understanding', 'Build case handling awareness', 'Improve observation skills', 'Develop patient interaction confidence'],
          ['Focus on treatment planning', 'Strengthen professional discipline', 'Improve rehabilitation application', 'Prepare for advanced practice'],
          ['Develop practical clinical confidence', 'Improve documentation and reporting', 'Build career planning awareness', 'Strengthen therapy skills'],
          ['Advance clinical exposure', 'Improve independent work confidence', 'Prepare professional profile', 'Build patient management skills'],
          ['Project / research orientation', 'Prepare for interviews and internships', 'Strengthen profile building', 'Improve communication'],
          ['Finalize professional readiness', 'Prepare for clinical opportunities', 'Plan growth and specialization', 'Strengthen field confidence'],
        ],
        careers: ['Physiotherapist', 'Rehabilitation Specialist', 'Clinical Therapy Pathway'],
        certifications: ['Rehabilitation workshops', 'Patient communication', 'Clinical documentation'],
      ),
      'Software Engineering': const RoadmapModel(
        overview:
        'Software Engineering is a structured field focused on software development, applications, testing, systems, and project building.',
        semesters: [
          ['Learn programming fundamentals', 'Build problem solving skills', 'Improve logical thinking', 'Start C++ or Python basics'],
          ['Study OOP concepts', 'Learn database basics', 'Practice Git and GitHub', 'Create mini coding projects'],
          ['Study data structures', 'Learn frontend basics', 'Improve SQL practice', 'Develop teamwork skills'],
          ['Build web or app projects', 'Learn APIs and backend basics', 'Understand software design', 'Strengthen debugging skills'],
          ['Study testing basics', 'Improve software architecture understanding', 'Start portfolio building', 'Prepare for internship learning'],
          ['Choose specialization path', 'Build real-world projects', 'Learn deployment basics', 'Practice interview questions'],
          ['Start final year project direction', 'Improve CV and LinkedIn', 'Strengthen professional confidence', 'Explore freelancing or internships'],
          ['Complete projects professionally', 'Prepare for job applications', 'Improve communication and interviews', 'Plan long-term software career path'],
        ],
        careers: ['Software Engineer', 'Frontend Developer', 'Backend Developer', 'Mobile App Developer', 'QA Engineer'],
        certifications: ['Git/GitHub', 'Flutter', 'Web development', 'Cloud fundamentals'],
      ),
      'Computer Science': const RoadmapModel(
        overview:
        'Computer Science develops computing logic, systems understanding, software, and technical depth.',
        semesters: [
          ['Learn programming basics', 'Build problem solving skills', 'Improve logic and analytical thinking', 'Develop consistency in coding practice'],
          ['Study OOP and discrete structures', 'Improve algorithmic thinking', 'Build mini projects', 'Strengthen communication'],
          ['Learn data structures', 'Study algorithms in detail', 'Practice SQL and databases', 'Improve technical confidence'],
          ['Study operating systems and networks', 'Understand system-level computing', 'Work on practical assignments', 'Improve presentation skills'],
          ['Build technical portfolio', 'Explore web, app, or systems path', 'Practice coding interviews', 'Improve project quality'],
          ['Study advanced CS topics', 'Take part in real development work', 'Strengthen internships/freelance readiness', 'Improve debugging depth'],
          ['Start final project planning', 'Choose future specialization', 'Strengthen professional profile', 'Prepare for job market'],
          ['Complete technical projects', 'Apply for jobs or higher study', 'Strengthen interviews', 'Plan advanced learning direction'],
        ],
        careers: ['Computer Scientist', 'Software Engineer', 'Systems Engineer', 'Research Assistant'],
        certifications: ['DSA practice', 'Linux basics', 'Cloud basics', 'GitHub portfolio'],
      ),
      'Artificial Intelligence': const RoadmapModel(
        overview:
        'Artificial Intelligence combines programming, mathematics, machine learning, and smart systems.',
        semesters: [
          ['Learn Python and programming basics', 'Build logic and problem solving', 'Strengthen mathematics foundation', 'Understand AI field basics'],
          ['Study statistics and linear algebra basics', 'Learn data handling', 'Build mini coding projects', 'Improve analytical thinking'],
          ['Start machine learning basics', 'Understand data preprocessing', 'Practice simple models', 'Improve coding discipline'],
          ['Learn deep learning foundations', 'Study neural networks', 'Build small AI experiments', 'Improve project documentation'],
          ['Study model evaluation', 'Strengthen AI concepts and applications', 'Build portfolio projects', 'Improve communication of technical ideas'],
          ['Explore NLP or computer vision basics', 'Improve implementation skills', 'Prepare for internships', 'Learn deployment basics'],
          ['Start capstone/FYP direction', 'Work on real AI solution ideas', 'Strengthen CV and LinkedIn', 'Prepare for interviews'],
          ['Complete AI projects professionally', 'Apply for jobs or higher study', 'Strengthen technical confidence', 'Plan specialization path'],
        ],
        careers: ['AI Engineer', 'ML Engineer', 'NLP Associate', 'AI Developer'],
        certifications: ['Python', 'Machine Learning', 'Deep Learning', 'Cloud AI basics'],
      ),
      'Civil Engineering': const RoadmapModel(
        overview:
        'Civil Engineering focuses on structures, site work, construction systems, and infrastructure planning.',
        semesters: [
          ['Strengthen mathematics basics', 'Learn engineering drawing', 'Build concept discipline', 'Improve communication'],
          ['Study mechanics basics', 'Understand surveying concepts', 'Improve practical confidence', 'Strengthen problem solving'],
          ['Learn structures basics', 'Understand construction materials', 'Practice AutoCAD basics', 'Improve lab discipline'],
          ['Study design concepts', 'Improve report writing', 'Understand site observations', 'Build professional confidence'],
          ['Strengthen structural analysis', 'Learn quantity estimation', 'Use relevant software tools', 'Build technical portfolio'],
          ['Study construction management', 'Prepare for internships', 'Understand real project workflow', 'Improve communication and teamwork'],
          ['Start final year project direction', 'Improve advanced design/site understanding', 'Build CV and profile', 'Prepare for interviews'],
          ['Complete technical projects', 'Apply for jobs', 'Strengthen site and office role readiness', 'Plan long-term specialization'],
        ],
        careers: ['Civil Engineer', 'Site Engineer', 'Structural Engineer', 'Quantity Surveyor'],
        certifications: ['AutoCAD', 'Quantity estimation', 'Project management basics'],
      ),
      'Electrical Engineering': const RoadmapModel(
        overview:
        'Electrical Engineering focuses on circuits, machines, power systems, and electronics.',
        semesters: [
          ['Strengthen math and physics', 'Learn circuit fundamentals', 'Develop disciplined study habits', 'Improve technical confidence'],
          ['Study electrical fundamentals deeply', 'Build lab confidence', 'Practice numerical problem solving', 'Improve concept clarity'],
          ['Learn electronics basics', 'Understand signals and systems', 'Strengthen practical work', 'Improve note quality'],
          ['Study machines and power systems', 'Improve technical presentation skills', 'Strengthen laboratory understanding', 'Build project mindset'],
          ['Explore control systems or advanced concepts', 'Use technical tools/software', 'Build mini projects', 'Prepare for internships'],
          ['Choose specialization direction', 'Improve practical confidence', 'Strengthen communication', 'Practice interviews'],
          ['Start FYP/capstone direction', 'Build CV and profile', 'Improve advanced technical understanding', 'Prepare for industry'],
          ['Complete engineering projects', 'Apply for jobs', 'Strengthen industry readiness', 'Plan long-term growth'],
        ],
        careers: ['Electrical Engineer', 'Power Engineer', 'Electronics Associate'],
        certifications: ['MATLAB basics', 'Electrical tools', 'Project documentation'],
      ),
      'Mechanical Engineering': const RoadmapModel(
        overview:
        'Mechanical Engineering focuses on mechanics, machines, design, and manufacturing systems.',
        semesters: [
          ['Strengthen mathematics and physics', 'Understand mechanics basics', 'Improve discipline and communication', 'Build technical confidence'],
          ['Study engineering drawing', 'Learn workshop practice', 'Understand thermodynamics basics', 'Improve class consistency'],
          ['Study machine elements and mechanics', 'Improve lab performance', 'Practice problem solving', 'Build better technical notes'],
          ['Learn manufacturing and design basics', 'Work on mini projects', 'Improve practical understanding', 'Build presentation skills'],
          ['Study advanced thermal and machine systems', 'Explore software tools', 'Build portfolio quality', 'Prepare for internships'],
          ['Choose industrial/design direction', 'Improve real-world engineering understanding', 'Practice interview readiness', 'Strengthen communication'],
          ['Start FYP direction', 'Build CV and professional profile', 'Strengthen technical confidence', 'Prepare for the job market'],
          ['Complete engineering projects', 'Apply for jobs', 'Plan career specialization', 'Continue technical improvement'],
        ],
        careers: ['Mechanical Engineer', 'Design Engineer', 'Industrial Engineer'],
        certifications: ['CAD tools', 'Workshop exposure', 'Project documentation'],
      ),
      'BBA': const RoadmapModel(
        overview:
        'BBA focuses on business fundamentals, management, communication, and practical business understanding.',
        semesters: [
          ['Learn business basics', 'Improve communication and presentation', 'Develop discipline and confidence', 'Understand management fundamentals'],
          ['Study management and accounting basics', 'Improve teamwork and class participation', 'Build note quality', 'Develop presentation confidence'],
          ['Learn marketing and business communication', 'Understand case studies', 'Improve report writing', 'Build leadership skills'],
          ['Study HR and operations basics', 'Build analysis skills', 'Develop teamwork confidence', 'Improve academic performance'],
          ['Choose specialization interest', 'Prepare for internships', 'Build CV and LinkedIn', 'Strengthen business awareness'],
          ['Gain practical exposure', 'Improve professional communication', 'Work on business projects', 'Prepare for interviews'],
          ['Start final project direction', 'Build professional network', 'Improve profile strength', 'Plan future career path'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Improve confidence in business roles', 'Continue long-term development'],
        ],
        careers: ['Business Executive', 'Management Trainee', 'HR Associate', 'Operations Associate'],
        certifications: ['Excel', 'Business communication', 'Project management basics'],
      ),
      'Accounting and Finance': const RoadmapModel(
        overview:
        'Accounting and Finance develops financial understanding, accounting accuracy, and business decision skills.',
        semesters: [
          ['Learn accounting basics', 'Develop discipline and communication', 'Strengthen Excel familiarity', 'Build confidence with numbers'],
          ['Study financial accounting', 'Improve accuracy and consistency', 'Practice reports and assignments', 'Strengthen class preparation'],
          ['Learn managerial accounting', 'Understand finance foundations', 'Improve analytical thinking', 'Develop reporting quality'],
          ['Study financial analysis', 'Improve presentation of financial ideas', 'Strengthen technical understanding', 'Build case analysis confidence'],
          ['Explore advanced finance/accounting concepts', 'Prepare for internships', 'Build CV and profile', 'Strengthen professional communication'],
          ['Improve real-world finance understanding', 'Build interview readiness', 'Strengthen analytical skills', 'Prepare for workplace expectations'],
          ['Start final project/capstone', 'Build networking and professional confidence', 'Prepare job application material', 'Strengthen profile'],
          ['Complete projects professionally', 'Apply for accounting/finance roles', 'Plan future certifications', 'Continue professional growth'],
        ],
        careers: ['Accountant', 'Finance Analyst', 'Audit Associate', 'Banking Roles'],
        certifications: ['Excel', 'Financial modeling basics', 'Accounting software basics'],
      ),
      'Psychology': const RoadmapModel(
        overview:
        'Psychology develops understanding of human behavior, communication, research, and counseling-related skills.',
        semesters: [
          ['Learn psychology basics', 'Build empathy and communication', 'Develop note-making habits', 'Strengthen academic discipline'],
          ['Study psychological theories', 'Improve reading and understanding', 'Build confidence in class work', 'Strengthen communication'],
          ['Learn research basics', 'Improve observation skills', 'Develop academic writing', 'Work on mini assignments'],
          ['Study applied psychology basics', 'Improve case understanding', 'Strengthen ethical awareness', 'Build presentation skills'],
          ['Gain practical understanding', 'Develop report writing', 'Build professional behavior', 'Prepare for internships'],
          ['Explore advanced topics', 'Improve profile building', 'Strengthen communication confidence', 'Prepare for interviews'],
          ['Start final project/capstone', 'Build CV and professional image', 'Improve career direction clarity', 'Strengthen field understanding'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan future specialization', 'Continue professional growth'],
        ],
        careers: ['Psychologist', 'Counselor', 'HR Support', 'Research Assistant'],
        certifications: ['Counseling workshops', 'Research basics', 'Communication skills'],
      ),
      'Data Science': const RoadmapModel(
        overview:
        'Data Science combines statistics, programming, data analysis, and machine learning to solve real-world problems using data.',
        semesters: [
          ['Build Python and programming basics', 'Strengthen mathematics and statistics foundation', 'Develop logical and analytical thinking', 'Improve study discipline'],
          ['Learn data handling and preprocessing basics', 'Study probability and statistics in depth', 'Practice small analysis tasks', 'Improve note quality and consistency'],
          ['Work on data visualization and exploratory analysis', 'Learn SQL and database basics', 'Build mini data projects', 'Strengthen communication of findings'],
          ['Study machine learning basics', 'Practice model building and evaluation', 'Improve project documentation', 'Develop confidence in tools and workflows'],
          ['Work on practical datasets and case studies', 'Improve portfolio quality', 'Explore business and real-world applications', 'Build technical confidence'],
          ['Study advanced analytics or ML applications', 'Improve reporting and communication skills', 'Prepare for internships', 'Strengthen professional profile'],
          ['Start final project direction', 'Build CV and LinkedIn', 'Practice interviews and problem solving', 'Strengthen career clarity'],
          ['Complete projects professionally', 'Apply for jobs or higher study', 'Improve industry readiness', 'Plan long-term data career growth'],
        ],
        careers: ['Data Scientist', 'Data Analyst', 'Business Intelligence Associate', 'ML Associate'],
        certifications: ['Python for data analysis', 'SQL', 'Machine Learning basics', 'Data visualization tools'],
      ),
      'Cyber Security': const RoadmapModel(
        overview:
        'Cyber Security focuses on protecting systems, networks, and data through security analysis, risk awareness, and defensive technical skills.',
        semesters: [
          ['Learn computer and networking basics', 'Build problem solving and logical thinking', 'Improve discipline and consistency', 'Understand security field fundamentals'],
          ['Study operating systems and networking concepts', 'Strengthen Linux basics', 'Improve technical confidence', 'Develop a practical mindset'],
          ['Learn security fundamentals and threat awareness', 'Understand vulnerabilities and safe practices', 'Practice technical labs', 'Improve documentation skills'],
          ['Study ethical hacking and defense concepts', 'Strengthen system and network understanding', 'Improve analytical thinking', 'Build mini security projects'],
          ['Explore incident response and risk management', 'Improve reporting quality', 'Prepare for internships', 'Build portfolio confidence'],
          ['Study advanced security tools and workflows', 'Practice real-world scenarios', 'Improve communication and teamwork', 'Strengthen interview readiness'],
          ['Start final project direction', 'Build CV and LinkedIn', 'Prepare certifications pathway', 'Strengthen professional confidence'],
          ['Complete technical projects', 'Apply for jobs or higher study', 'Improve readiness for SOC and analyst roles', 'Plan long-term security growth'],
        ],
        careers: ['Cyber Security Analyst', 'SOC Analyst', 'Information Security Associate', 'Security Engineer'],
        certifications: ['Network security basics', 'Linux basics', 'Security+ style preparation', 'Incident response basics'],
      ),
      'Architecture': const RoadmapModel(
        overview:
        'Architecture is a design-focused field that combines creativity, technical drawing, visual planning, and structural understanding.',
        semesters: [
          ['Build design basics', 'Improve sketching and drawing skills', 'Develop creative thinking', 'Strengthen discipline and presentation habits'],
          ['Understand visual planning and studio work', 'Improve observation and concept development', 'Build portfolio beginnings', 'Develop communication confidence'],
          ['Learn architectural design basics', 'Build software awareness', 'Improve model and presentation quality', 'Strengthen project discipline'],
          ['Study theory and design development', 'Improve creativity with structure', 'Build stronger studio confidence', 'Learn to present ideas clearly'],
          ['Use architecture-related software tools', 'Strengthen portfolio quality', 'Develop professional identity', 'Prepare for internships'],
          ['Understand real-world design workflow', 'Improve communication with clients and teams', 'Build practical design confidence', 'Strengthen professional behavior'],
          ['Start final project direction', 'Build CV and design portfolio', 'Prepare for interviews and opportunities', 'Improve concept and presentation strength'],
          ['Complete final project professionally', 'Apply for jobs or higher study', 'Strengthen career direction', 'Plan long-term design growth'],
        ],
        careers: ['Architect', 'Design Associate', 'Interior Design Pathway', 'Built Environment Roles'],
        certifications: ['Design software', 'Portfolio development', 'Presentation workshops'],
      ),
      'Marketing': const RoadmapModel(
        overview:
        'Marketing focuses on branding, communication, campaigns, customer understanding, and business growth strategies.',
        semesters: [
          ['Learn marketing basics', 'Improve communication and presentation', 'Build creativity and confidence', 'Develop class discipline'],
          ['Study consumer behavior basics', 'Improve writing and speaking', 'Understand campaigns and branding basics', 'Strengthen teamwork'],
          ['Learn branding concepts in depth', 'Understand digital awareness', 'Work on mini marketing tasks', 'Improve professional communication'],
          ['Study market research and case analysis', 'Improve presentations and reports', 'Build portfolio beginnings', 'Strengthen confidence in ideas'],
          ['Choose specialization interest', 'Prepare for internships', 'Build CV and profile', 'Improve practical marketing understanding'],
          ['Develop campaign planning confidence', 'Improve interviews and networking', 'Strengthen content and communication', 'Build professional presence'],
          ['Start final project direction', 'Build stronger portfolio', 'Prepare job materials', 'Improve strategic thinking'],
          ['Complete projects professionally', 'Apply for jobs', 'Plan long-term marketing growth', 'Continue learning and specialization'],
        ],
        careers: ['Marketing Executive', 'Brand Associate', 'Digital Marketing Associate', 'Content / Campaign Roles'],
        certifications: ['Digital marketing basics', 'Communication workshops', 'Presentation skills'],
      ),
      'Economics': const RoadmapModel(
        overview:
        'Economics helps students understand markets, policy, finance, behavior, and decision making in business and society.',
        semesters: [
          ['Learn economics basics', 'Strengthen analytical thinking', 'Improve communication and discipline', 'Build strong reading habits'],
          ['Study micro and macroeconomics foundations', 'Practice graphs and numerical understanding', 'Improve note making', 'Develop confidence in academic work'],
          ['Build case understanding and policy awareness', 'Improve writing and explanation skills', 'Strengthen consistency', 'Develop research mindset'],
          ['Study applied economics and analysis', 'Improve presentations and reports', 'Build stronger critical thinking', 'Develop confidence in discussions'],
          ['Explore finance, policy, and development areas', 'Prepare for internships', 'Build profile and CV', 'Improve career clarity'],
          ['Strengthen economic reasoning in real-world contexts', 'Improve interview readiness', 'Develop analytical communication', 'Build professional confidence'],
          ['Start project/research direction', 'Strengthen profile and networking', 'Prepare applications', 'Improve specialization clarity'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term economics-related growth', 'Continue advanced learning'],
        ],
        careers: ['Economist', 'Policy Associate', 'Research Assistant', 'Business / Analysis Roles'],
        certifications: ['Excel', 'Research basics', 'Economic analysis tools'],
      ),
      'Banking': const RoadmapModel(
        overview:
        'Banking builds financial understanding, customer service skills, analytical confidence, and professional discipline for finance-sector roles.',
        semesters: [
          ['Build accounting and finance basics', 'Improve communication confidence', 'Strengthen discipline', 'Develop comfort with numbers'],
          ['Study banking concepts and financial basics', 'Improve accuracy and class performance', 'Strengthen professional habits', 'Build confidence in business communication'],
          ['Understand customer service and banking operations', 'Improve reports and assignments', 'Develop analytical thinking', 'Strengthen teamwork'],
          ['Study financial products and services', 'Improve presentation skills', 'Build awareness of risk and compliance', 'Develop professional confidence'],
          ['Prepare for internships and practical exposure', 'Build CV and profile', 'Improve interview readiness', 'Understand banking workflow better'],
          ['Strengthen workplace communication', 'Build confidence in financial service roles', 'Improve reporting and client interaction', 'Prepare for graduate roles'],
          ['Start final project direction', 'Strengthen networking', 'Build profile further', 'Refine career direction'],
          ['Complete projects professionally', 'Apply for banking/finance jobs', 'Plan future certifications', 'Continue long-term growth'],
        ],
        careers: ['Banking Officer', 'Customer Relationship Officer', 'Finance Associate', 'Operations Associate'],
        certifications: ['Excel', 'Financial services basics', 'Professional communication'],
      ),
      'English': const RoadmapModel(
        overview:
        'English builds language expertise, literature understanding, communication skills, writing ability, and academic analysis.',
        semesters: [
          ['Build strong reading habits', 'Improve grammar and writing basics', 'Develop communication confidence', 'Strengthen discipline and routine'],
          ['Study literature and language in depth', 'Improve comprehension and expression', 'Build class discussion confidence', 'Strengthen note-making skills'],
          ['Improve academic writing and analysis', 'Develop presentation confidence', 'Build interpretation skills', 'Strengthen reading consistency'],
          ['Study critical thinking and literary analysis', 'Improve speaking and explanation quality', 'Develop stronger communication style', 'Build confidence in academic work'],
          ['Explore teaching, content, and research interests', 'Prepare profile and CV', 'Improve portfolio or writing samples', 'Build professional confidence'],
          ['Improve interviews and communication', 'Develop specialization direction', 'Strengthen writing quality', 'Prepare for internships or work opportunities'],
          ['Start final project/research direction', 'Build academic profile', 'Strengthen presentation and professional image', 'Prepare future plans'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term growth in language-related fields', 'Continue advanced learning'],
        ],
        careers: ['Teacher / Lecturer', 'Content Writer', 'Research Assistant', 'Communication Roles'],
        certifications: ['Academic writing', 'Public speaking', 'Content writing basics'],
      ),
      'Media Studies': const RoadmapModel(
        overview:
        'Media Studies develops communication, storytelling, analysis, production awareness, and media industry understanding.',
        semesters: [
          ['Learn media basics', 'Improve communication and confidence', 'Develop observation and creativity', 'Strengthen discipline'],
          ['Study communication theories', 'Improve writing and speaking', 'Build stronger understanding of media platforms', 'Strengthen class participation'],
          ['Learn reporting/content basics', 'Improve presentation confidence', 'Develop audience understanding', 'Build creative thinking'],
          ['Study production and media analysis', 'Improve teamwork and project work', 'Develop professional confidence', 'Strengthen reporting/documentation skills'],
          ['Explore practical media interests', 'Prepare for internships', 'Build CV and profile', 'Improve communication quality'],
          ['Strengthen portfolio and practical confidence', 'Improve interviews and networking', 'Build media industry awareness', 'Develop stronger specialization clarity'],
          ['Start final project direction', 'Build stronger personal brand/profile', 'Prepare applications', 'Strengthen professional image'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term media growth', 'Continue practical improvement'],
        ],
        careers: ['Media Associate', 'Content Creator', 'Reporter', 'Communication Executive'],
        certifications: ['Presentation skills', 'Digital content basics', 'Communication workshops'],
      ),
      'International Relations': const RoadmapModel(
        overview:
        'International Relations develops awareness of global affairs, diplomacy, policy, communication, and analytical thinking.',
        semesters: [
          ['Build strong reading habits', 'Improve communication and writing', 'Develop awareness of global issues', 'Strengthen discipline and routine'],
          ['Study political and international concepts', 'Improve note quality and class preparation', 'Develop analytical thinking', 'Build confidence in discussion'],
          ['Improve policy understanding', 'Strengthen research and reading discipline', 'Develop presentation confidence', 'Build awareness of international systems'],
          ['Study diplomacy and international issues in depth', 'Improve writing quality', 'Strengthen academic analysis', 'Develop stronger communication'],
          ['Explore research, policy, and communication interests', 'Build CV and profile', 'Prepare for internships', 'Improve professional image'],
          ['Improve interviews and analytical communication', 'Develop networking confidence', 'Strengthen profile', 'Build clearer specialization direction'],
          ['Start final project/research direction', 'Improve report writing and presentation', 'Prepare applications', 'Strengthen professional confidence'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term policy or IR growth', 'Continue advanced learning'],
        ],
        careers: ['Policy Associate', 'Research Assistant', 'NGO / Development Roles', 'Diplomatic Pathway Support Roles'],
        certifications: ['Research basics', 'Communication skills', 'Report writing'],
      ),
      'Education': const RoadmapModel(
        overview:
        'Education focuses on teaching, learning systems, communication, and academic development for future educators and trainers.',
        semesters: [
          ['Build communication and presentation confidence', 'Develop reading and writing habits', 'Strengthen discipline and academic consistency', 'Understand education basics'],
          ['Study learning and teaching concepts', 'Improve classroom communication', 'Develop confidence in explanations', 'Build note quality'],
          ['Learn instructional strategies', 'Improve writing and assignments', 'Build practical teaching awareness', 'Strengthen class participation'],
          ['Study curriculum and classroom-related concepts', 'Improve presentation skills', 'Develop leadership in academic settings', 'Build professional behavior'],
          ['Prepare for internships or teaching exposure', 'Build CV and profile', 'Improve confidence in educational settings', 'Strengthen communication quality'],
          ['Develop stronger teaching confidence', 'Improve interviews and professional readiness', 'Build profile further', 'Prepare for real opportunities'],
          ['Start final project/research direction', 'Improve presentation and reporting', 'Strengthen academic image', 'Prepare future plans'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term education career growth', 'Continue professional development'],
        ],
        careers: ['Teacher', 'Education Coordinator', 'Academic Support Roles', 'Trainer'],
        certifications: ['Teaching workshops', 'Communication skills', 'Presentation practice'],
      ),
      'Biotechnology': const RoadmapModel(
        overview:
        'Biotechnology combines biology, laboratory science, research, and innovation to solve health, agricultural, and industrial problems.',
        semesters: [
          ['Build biology and chemistry basics', 'Develop research interest', 'Improve discipline and observation', 'Strengthen lab mindset'],
          ['Study molecular and biological fundamentals', 'Improve practical understanding', 'Build stronger note quality', 'Develop consistency in academic work'],
          ['Learn genetics and cell-related concepts', 'Improve scientific thinking', 'Strengthen lab confidence', 'Build communication in science topics'],
          ['Study applied biotechnology concepts', 'Improve research and report writing', 'Develop academic confidence', 'Build presentation quality'],
          ['Explore health, agriculture, or industrial biotech interests', 'Prepare for internships or projects', 'Strengthen profile building', 'Improve field clarity'],
          ['Develop project and lab confidence', 'Strengthen communication and teamwork', 'Build interview readiness', 'Prepare for higher opportunities'],
          ['Start final project/research direction', 'Build CV and academic profile', 'Strengthen specialization direction', 'Prepare future plans'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Plan long-term research/biotech growth', 'Continue advanced learning'],
        ],
        careers: ['Biotechnology Associate', 'Research Assistant', 'Lab Professional', 'Biotech Industry Roles'],
        certifications: ['Lab techniques', 'Research basics', 'Scientific communication'],
      ),
      'Media Sciences': const RoadmapModel(
        overview:
        'Media Sciences develops communication, storytelling, content creation, audience understanding, and media industry awareness.',
        semesters: [
          ['Build communication confidence', 'Improve writing and speaking', 'Develop creativity and discipline', 'Understand media basics'],
          ['Study communication and media concepts', 'Improve presentation quality', 'Build content awareness', 'Strengthen class participation'],
          ['Learn production/content foundations', 'Improve audience understanding', 'Develop mini creative work', 'Strengthen confidence in expression'],
          ['Study practical media and communication work', 'Improve teamwork and documentation', 'Build project mindset', 'Develop professional confidence'],
          ['Explore content, communication, or production interests', 'Prepare profile and CV', 'Build portfolio beginnings', 'Improve professional image'],
          ['Strengthen portfolio and communication', 'Improve interview readiness', 'Develop stronger specialization awareness', 'Prepare for internships'],
          ['Start final project direction', 'Build stronger personal profile', 'Improve project presentation', 'Plan future path'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Strengthen industry readiness', 'Continue creative growth'],
        ],
        careers: ['Media Associate', 'Content Creator', 'Communication Executive', 'Production Support Roles'],
        certifications: ['Presentation skills', 'Digital content basics', 'Media communication workshops'],
      ),
      'English Literature': const RoadmapModel(
        overview:
        'English Literature strengthens reading, analysis, writing, language depth, and communication confidence.',
        semesters: [
          ['Build strong reading habits', 'Improve grammar and writing basics', 'Develop communication confidence', 'Strengthen discipline and consistency'],
          ['Study literature and language foundations', 'Improve comprehension and expression', 'Build class confidence', 'Develop note quality'],
          ['Learn literary analysis', 'Improve writing and explanation style', 'Build academic confidence', 'Strengthen reading discipline'],
          ['Study critical and thematic analysis', 'Improve presentation confidence', 'Develop stronger interpretation skills', 'Build communication quality'],
          ['Explore teaching, writing, or research direction', 'Build profile and samples', 'Improve professional confidence', 'Prepare for opportunities'],
          ['Strengthen interviews and academic communication', 'Develop clearer specialization interest', 'Build stronger profile', 'Prepare future plans'],
          ['Start project/research direction', 'Build CV and presentation confidence', 'Strengthen academic image', 'Plan next steps'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term literature/language growth', 'Build future expertise'],
        ],
        careers: ['Teacher / Lecturer', 'Writer', 'Research Assistant', 'Communication Roles'],
        certifications: ['Academic writing', 'Content writing', 'Public speaking'],
      ),
      'Education Leadership': const RoadmapModel(
        overview:
        'Education Leadership focuses on teaching systems, communication, administration, and academic management.',
        semesters: [
          ['Build communication and leadership confidence', 'Develop discipline and academic consistency', 'Improve reading and writing habits', 'Understand education basics'],
          ['Study teaching and learning concepts', 'Improve class presentation', 'Build confidence in explanation', 'Strengthen organization skills'],
          ['Learn education systems and classroom planning', 'Improve report writing', 'Develop teamwork and leadership attitude', 'Build professional habits'],
          ['Study academic coordination and administration concepts', 'Improve communication quality', 'Build problem solving confidence', 'Strengthen professional image'],
          ['Prepare for internships and professional exposure', 'Build profile and CV', 'Improve confidence in educational environments', 'Strengthen networking'],
          ['Develop management and academic leadership awareness', 'Improve interviews and presentation', 'Build stronger profile', 'Prepare future plans'],
          ['Start project/research direction', 'Improve academic and professional communication', 'Strengthen leadership image', 'Prepare for opportunities'],
          ['Complete project professionally', 'Apply for roles or higher study', 'Plan long-term education leadership growth', 'Continue development'],
        ],
        careers: ['Academic Coordinator', 'Teacher / Trainer', 'Education Management Roles', 'School Administration Support'],
        certifications: ['Teaching workshops', 'Leadership communication', 'Presentation practice'],
      ),
      'Information Technology': const RoadmapModel(
        overview:
        'Information Technology focuses on systems, networks, support, software, and practical technical operations.',
        semesters: [
          ['Learn computer basics and programming introduction', 'Build technical confidence', 'Develop discipline and consistency', 'Improve logical thinking'],
          ['Study networking and operating system basics', 'Strengthen practical understanding', 'Improve note quality', 'Build communication skills'],
          ['Learn databases and web/system basics', 'Build mini practical tasks', 'Improve technical discipline', 'Develop teamwork confidence'],
          ['Study system support and infrastructure concepts', 'Improve practical troubleshooting', 'Build confidence with tools', 'Strengthen project mindset'],
          ['Explore networking, support, or development direction', 'Build technical profile', 'Prepare for internships', 'Improve professional behavior'],
          ['Strengthen real-world IT workflow understanding', 'Improve interviews and communication', 'Build stronger profile', 'Prepare job readiness'],
          ['Start final project direction', 'Build CV and practical confidence', 'Strengthen specialization direction', 'Prepare applications'],
          ['Complete project professionally', 'Apply for jobs', 'Plan long-term IT growth', 'Continue certifications and learning'],
        ],
        careers: ['IT Support Engineer', 'Systems Associate', 'Network Support Roles', 'IT Operations Associate'],
        certifications: ['Networking basics', 'System administration basics', 'Helpdesk / support skills'],
      ),
      'Business Analytics': const RoadmapModel(
        overview:
        'Business Analytics combines business understanding, data interpretation, reporting, and decision support skills.',
        semesters: [
          ['Build business and data basics', 'Improve Excel confidence', 'Develop analytical thinking', 'Strengthen communication'],
          ['Study reporting and business concepts', 'Improve numerical understanding', 'Build note quality', 'Develop discipline'],
          ['Learn data analysis basics', 'Improve charts, reporting, and interpretation', 'Build mini analysis tasks', 'Strengthen confidence with business data'],
          ['Study applied analytics and case understanding', 'Improve presentation quality', 'Develop stronger analytical communication', 'Build project confidence'],
          ['Explore practical analytics/business direction', 'Prepare CV and profile', 'Improve tool usage', 'Prepare for internships'],
          ['Strengthen professional reporting and interviews', 'Develop profile and communication', 'Build business confidence', 'Prepare for workplace tasks'],
          ['Start final project direction', 'Build stronger portfolio', 'Improve networking and presentation', 'Plan future path'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Strengthen readiness for analyst roles', 'Continue long-term growth'],
        ],
        careers: ['Business Analyst', 'Reporting Associate', 'Operations / Strategy Support', 'Data-driven Business Roles'],
        certifications: ['Excel', 'Dashboard/reporting basics', 'Business communication'],
      ),
      'Finance': const RoadmapModel(
        overview:
        'Finance builds understanding of money management, financial decision making, investment basics, and business analysis.',
        semesters: [
          ['Learn finance basics', 'Improve numerical confidence', 'Develop discipline and communication', 'Strengthen analytical mindset'],
          ['Study accounting and finance foundations', 'Improve report quality', 'Build confidence in calculations', 'Develop consistency'],
          ['Learn business finance concepts', 'Improve interpretation and presentation', 'Build academic confidence', 'Strengthen profile thinking'],
          ['Study applied finance and analysis', 'Improve case understanding', 'Build communication for financial ideas', 'Develop stronger confidence'],
          ['Explore practical finance roles and interests', 'Build CV and profile', 'Prepare for internships', 'Improve interview readiness'],
          ['Strengthen real-world finance understanding', 'Improve analytical communication', 'Build professional confidence', 'Prepare future direction'],
          ['Start final project direction', 'Strengthen networking and profile', 'Prepare job materials', 'Plan certification path'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term finance growth', 'Build stronger expertise'],
        ],
        careers: ['Finance Analyst', 'Investment Support Roles', 'Corporate Finance Associate', 'Banking / Finance Roles'],
        certifications: ['Excel', 'Financial analysis basics', 'Report writing'],
      ),
      'Interior Design': const RoadmapModel(
        overview:
        'Interior Design focuses on creative planning, space aesthetics, client understanding, and practical design development.',
        semesters: [
          ['Build design sense and observation', 'Improve sketching and creativity', 'Develop communication confidence', 'Strengthen discipline and presentation habits'],
          ['Study design basics and space understanding', 'Improve color and style awareness', 'Build note quality', 'Develop confidence in idea sharing'],
          ['Learn layout and design planning concepts', 'Improve model and presentation quality', 'Build project mindset', 'Strengthen software awareness'],
          ['Study practical interior concepts', 'Improve client understanding', 'Develop stronger design confidence', 'Build presentation skills'],
          ['Explore real project direction', 'Build CV and portfolio', 'Prepare for internships', 'Improve professional image'],
          ['Strengthen design communication and confidence', 'Improve interviews and networking', 'Develop specialization clarity', 'Prepare future opportunities'],
          ['Start final project direction', 'Build stronger portfolio', 'Prepare job materials', 'Strengthen presentation quality'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term creative growth', 'Build stronger design profile'],
        ],
        careers: ['Interior Designer', 'Space Planner', 'Design Associate'],
        certifications: ['Design software basics', 'Portfolio development', 'Presentation skills'],
      ),
      'International Business': const RoadmapModel(
        overview:
        'International Business develops business understanding, global market awareness, communication, and strategic thinking.',
        semesters: [
          ['Learn business basics', 'Improve communication confidence', 'Develop discipline and consistency', 'Build awareness of global trade concepts'],
          ['Study management and business fundamentals', 'Improve presentation and teamwork', 'Build note quality', 'Develop confidence in class work'],
          ['Learn global business concepts', 'Improve analytical understanding', 'Build report writing skills', 'Strengthen communication'],
          ['Study strategy and international business cases', 'Improve professional thinking', 'Build stronger presentations', 'Develop confidence in analysis'],
          ['Explore career interests and internships', 'Build CV and profile', 'Improve interviews', 'Strengthen professional image'],
          ['Strengthen practical business understanding', 'Improve networking and communication', 'Build workplace confidence', 'Prepare for opportunities'],
          ['Start final project direction', 'Strengthen profile and applications', 'Improve business communication', 'Clarify future plans'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term business growth', 'Build stronger career identity'],
        ],
        careers: ['Business Associate', 'International Trade Support Roles', 'Management Trainee', 'Operations Roles'],
        certifications: ['Business communication', 'Excel', 'Professional presentation'],
      ),
      'Human Resource Management': const RoadmapModel(
        overview:
        'Human Resource Management focuses on people management, communication, recruitment, workplace behavior, and organizational systems.',
        semesters: [
          ['Build communication and confidence', 'Understand workplace behavior basics', 'Develop discipline and teamwork', 'Improve reading and writing'],
          ['Study HR and management foundations', 'Improve presentations and class interaction', 'Build stronger understanding of organizational roles', 'Develop note quality'],
          ['Learn recruitment and people management basics', 'Improve observation and communication', 'Build analytical confidence', 'Strengthen professional attitude'],
          ['Study HR operations and employee support concepts', 'Improve reporting and presentation', 'Develop case understanding', 'Build stronger confidence'],
          ['Prepare for internships and HR roles', 'Build CV and profile', 'Improve interviews', 'Strengthen professional image'],
          ['Develop practical HR awareness', 'Improve networking and workplace communication', 'Build stronger profile', 'Clarify future growth direction'],
          ['Start final project direction', 'Improve professional confidence', 'Prepare applications', 'Strengthen long-term planning'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term HR growth', 'Build stronger workplace readiness'],
        ],
        careers: ['HR Associate', 'Recruitment Coordinator', 'People Operations Roles', 'Training Support Roles'],
        certifications: ['Communication skills', 'Interview coordination basics', 'Workplace professionalism'],
      ),
      'English Language': const RoadmapModel(
        overview:
        'English Language focuses on grammar, writing, communication, language structure, and professional expression.',
        semesters: [
          ['Build grammar and writing basics', 'Improve communication confidence', 'Develop reading habits', 'Strengthen discipline'],
          ['Study language concepts deeply', 'Improve comprehension and vocabulary', 'Build note quality', 'Develop confidence in speaking'],
          ['Learn writing and communication techniques', 'Improve analysis and expression', 'Build stronger academic confidence', 'Strengthen class participation'],
          ['Study applied language and communication', 'Improve presentation quality', 'Develop stronger professional expression', 'Build confidence in explanation'],
          ['Explore teaching, writing, or communication interests', 'Build profile and samples', 'Improve interview readiness', 'Prepare for opportunities'],
          ['Strengthen communication and career clarity', 'Build professional confidence', 'Improve profile quality', 'Develop stronger direction'],
          ['Start project/research direction', 'Improve academic and professional writing', 'Build CV and profile', 'Prepare future plans'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term language growth', 'Strengthen professional identity'],
        ],
        careers: ['Language Instructor', 'Content Writer', 'Communication Roles', 'Academic Support Roles'],
        certifications: ['Academic writing', 'Public speaking', 'Language teaching basics'],
      ),
      'Political Science': const RoadmapModel(
        overview:
        'Political Science builds understanding of governance, policy, institutions, civic systems, and analytical communication.',
        semesters: [
          ['Build strong reading habits', 'Improve writing and communication', 'Develop discipline and routine', 'Understand political basics'],
          ['Study governance and political concepts', 'Improve class preparation', 'Build confidence in discussion', 'Strengthen note quality'],
          ['Learn policy and institutional understanding', 'Improve analysis and reporting', 'Build academic confidence', 'Develop stronger communication'],
          ['Study political systems and applied topics', 'Improve presentations', 'Strengthen analytical thinking', 'Build confidence in academic work'],
          ['Explore research or public policy interests', 'Build CV and profile', 'Prepare for internships', 'Improve professional image'],
          ['Strengthen communication and interviews', 'Develop networking confidence', 'Build stronger direction', 'Prepare future opportunities'],
          ['Start final project/research direction', 'Improve writing and analysis quality', 'Prepare applications', 'Strengthen profile'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term political science growth', 'Build stronger professional identity'],
        ],
        careers: ['Policy Support Roles', 'Research Assistant', 'Public Sector Preparation', 'NGO / Civic Roles'],
        certifications: ['Research basics', 'Report writing', 'Public speaking'],
      ),
      'Public Administration': const RoadmapModel(
        overview:
        'Public Administration develops administrative thinking, policy understanding, communication, and organizational management skills.',
        semesters: [
          ['Build communication and discipline', 'Develop reading and writing habits', 'Understand administration basics', 'Improve confidence'],
          ['Study public systems and administration concepts', 'Improve class preparation', 'Develop note quality', 'Strengthen communication'],
          ['Learn policy and management basics', 'Improve report writing', 'Build confidence in presentations', 'Develop stronger organization skills'],
          ['Study applied administration and governance topics', 'Improve teamwork and case understanding', 'Build analytical confidence', 'Strengthen professionalism'],
          ['Explore administrative and policy interests', 'Prepare CV and profile', 'Improve interview readiness', 'Build stronger direction'],
          ['Strengthen communication and practical awareness', 'Develop professional confidence', 'Improve profile and networking', 'Prepare future opportunities'],
          ['Start final project/research direction', 'Improve documentation and applications', 'Strengthen professional image', 'Plan future path'],
          ['Complete project professionally', 'Apply for jobs or higher study', 'Continue long-term public administration growth', 'Build stronger readiness'],
        ],
        careers: ['Administrative Roles', 'Policy Support Roles', 'Development Sector Roles', 'Management Support Roles'],
        certifications: ['Professional communication', 'Report writing', 'Office / coordination basics'],
      ),
      'General Science': const RoadmapModel(
        overview:
        'General Science builds multidisciplinary scientific understanding, study discipline, and flexibility for multiple academic directions.',
        semesters: [
          ['Build strong science basics', 'Improve discipline and consistency', 'Develop curiosity and observation', 'Strengthen reading habits'],
          ['Study science concepts with clarity', 'Improve note making and revision', 'Build confidence in practical understanding', 'Develop stronger focus'],
          ['Explore different science-related paths', 'Understand merit and eligibility', 'Improve communication confidence', 'Build career clarity'],
          ['Prepare for admissions and future direction', 'Strengthen weak concepts', 'Improve confidence for transition', 'Plan the next step clearly'],
        ],
        careers: ['Science-related degree pathways', 'Lab support roles (later specialization)', 'Academic growth opportunities'],
        certifications: ['Study skills', 'Communication basics', 'Science workshops'],
      ),
      'Commerce': const RoadmapModel(
        overview:
        'Commerce develops understanding of accounting, trade, finance, business communication, and market systems.',
        semesters: [
          ['Build accounting and business basics', 'Improve numerical confidence', 'Develop communication discipline', 'Strengthen routine and consistency'],
          ['Study commerce concepts clearly', 'Improve class participation and notes', 'Build confidence in reports', 'Strengthen academic habits'],
          ['Explore business, finance, and management directions', 'Improve communication and confidence', 'Understand future academic options', 'Prepare long-term plans'],
          ['Strengthen weak areas', 'Prepare for admissions and transition', 'Build professional confidence', 'Finalize academic direction'],
        ],
        careers: ['Business pathways', 'Finance pathways', 'Accounting pathways'],
        certifications: ['Excel basics', 'Business communication', 'Numerical confidence training'],
      ),
    };

    return map[normalizedField] ??
        const RoadmapModel(
          overview:
          'This roadmap helps students build strong basics, improve skills, and prepare for future academic and career opportunities.',
          semesters: [
            [
              'Build your basic concepts strongly',
              'Improve study discipline and routine',
              'Understand your field clearly',
              'Develop communication confidence',
            ],
            [
              'Strengthen core concepts',
              'Practice academic consistency',
              'Improve note making and revision',
              'Develop practical understanding',
            ],
            [
              'Build technical and soft skills',
              'Take part in projects or learning tasks',
              'Improve teamwork and communication',
              'Prepare for future challenges',
            ],
            [
              'Plan your next academic and career steps',
              'Strengthen your profile',
              'Build confidence for future opportunities',
              'Continue growth with clear direction',
            ],
          ],
          careers: [
            'Field Specialist',
            'Graduate Trainee',
            'Professional Associate',
          ],
          certifications: [
            'Communication skills',
            'Relevant workshops',
            'Professional development',
          ],
        );
  }
}