class ClassRepository {
  static final List<Map<String, dynamic>> classes = [
    {
      'id': 1,
      'title': 'Desain Antarmuka & UI/UX',
      'code': 'DKV-301',
      'type': 'ui_ux',
      'instructor': 'Dr. Sarah Wijaya, M.Des',
      'rating': 4.7,
      'materi': _generateMateri(1, 'UI/UX'),
    },
    {
      'id': 2,
      'title': 'Mobile Programming',
      'code': 'IF-402',
      'type': 'mobile_programming',
      'instructor': 'Prof. Ahmad Rizki, M.Kom',
      'rating': 4.8,
      'materi': _generateMateri(2, 'Mobile Programming'),
    },
    {
      'id': 3,
      'title': 'Cyber Security',
      'code': 'CS-401',
      'type': 'cyber_security',
      'instructor': 'Ir. Budi Santoso, M.T.',
      'rating': 4.5,
      'materi': _generateMateri(3, 'Cyber Security'),
    },
    {
      'id': 4,
      'title': 'Web Programming',
      'code': 'IF-303',
      'type': 'web_programming',
      'instructor': 'Dra. Siti Nurhaliza, M.Sc',
      'rating': 4.6,
      'materi': _generateMateri(4, 'Web Programming'),
    },
  ];

  static List<Map<String, dynamic>> _generateMateri(int classId, String className) {
    List<String> titles;
    if (className == 'UI/UX') {
      titles = [
        'Pengantar UI/UX',
        'Design Thinking Process',
        'User Research & Persona',
        'Information Architecture',
        'Wireframing & Prototyping',
        'Visual Design Principles',
        'Usability Testing'
      ];
    } else if (className == 'Mobile Programming') {
      titles = [
        'Introduction to Flutter',
        'Dart Basics',
        'Widgets & Layouts',
        'State Management',
        'API & Networking',
        'Local Database',
        'Firebase Integration'
      ];
    } else if (className == 'Cyber Security') {
      titles = [
        'Pengantar Cyber Security',
        'Network Security',
        'Web Security',
        'Cryptography',
        'Malware Analysis',
        'Ethical Hacking',
        'Security Law'
      ];
    } else {
      titles = [
        'HTML & CSS',
        'Javascript Basics',
        'Modern CSS Frameworks',
        'React Fundamentals',
        'Backend with Node.js',
        'RESTful API',
        'Deployment'
      ];
    }

    return List.generate(titles.length, (index) {
      int p = index + 1;
      String title = titles[index];
      String classSlug = className.toLowerCase().replaceAll(' ', '_');
      
      // Map of unique sequential videos for each class (7 meetings each)
      final Map<String, List<String>> courseVideos = {
        'ui_ux': [
          'https://www.youtube.com/watch?v=zHAa-m16p30', // Intro to UI/UX
          'https://www.youtube.com/watch?v=5UfGZnxV-O8', // Design Thinking
          'https://www.youtube.com/watch?v=tIpxXJ_E_R4', // User Research
          'https://www.youtube.com/watch?v=q6OLeY_1R-g', // IA
          'https://www.youtube.com/watch?v=c9Wg6A_LhG4', // Wireframing
          'https://www.youtube.com/watch?v=0zf_G90iY6Q', // Visual Design
          'https://www.youtube.com/watch?v=pAnVIn_P998', // Usability Testing
        ],
        'mobile_programming': [
          'https://www.youtube.com/watch?v=VPvVD8t02U8', // Intro Flutter
          'https://www.youtube.com/watch?v=9f-O8Y3K6-Y', // Dart Basics
          'https://www.youtube.com/watch?v=jIDYgnNveoM', // Widgets
          'https://www.youtube.com/watch?v=3u_S-pX1v-U', // State Mgmt
          'https://www.youtube.com/watch?v=x0uC6YpY3u4', // API
          'https://www.youtube.com/watch?v=XvIsid0b_X4', // Local DB
          'https://www.youtube.com/watch?v=fJ79u6D-v6E', // Firebase
        ],
        'cyber_security': [
          'https://www.youtube.com/watch?v=inWWhr5tnEA', // Intro Cyber
          'https://www.youtube.com/watch?v=sdpxddDzXfE', // Network Security
          'https://www.youtube.com/watch?v=yO6WBeon1bY', // Web Security
          'https://www.youtube.com/watch?v=Nux_vS9P-M0', // Cryptography
          'https://www.youtube.com/watch?v=7_f9XNByK7M', // Malware
          'https://www.youtube.com/watch?v=2Lp-H7P5uW0', // Ethical Hacking
          'https://www.youtube.com/watch?v=X6OqYQv_N_k', // Security Law
        ],
        'web_programming': [
          'https://www.youtube.com/watch?v=kUMe1FH4CHE', // HTML/CSS
          'https://www.youtube.com/watch?v=W6NZfCO5SIk', // JS Basics
          'https://www.youtube.com/watch?v=Yf6pXpS1t8Q', // CSS Frameworks
          'https://www.youtube.com/watch?v=Ke90Tje7VS0', // React
          'https://www.youtube.com/watch?v=8uGZ9vU-M8Y', // Node.js
          'https://www.youtube.com/watch?v=7YcW25PHnAA', // RESTful API
          'https://www.youtube.com/watch?v=M576WGiDBdQ', // Deployment
        ],
      };

      String videoUrl = (courseVideos[classSlug] != null && courseVideos[classSlug]!.length >= p)
          ? courseVideos[classSlug]![index]
          : 'https://www.youtube.com/watch?v=1xIPqcWWMz8';

      // Determine if Zoom is available (only for recent meetings)
      bool isZoomAvailable = p >= (titles.length - 1); // Only last 2 meetings have active Zoom

      return {
        'id': p,
        'title': 'Pertemuan $p – $title',
        'description': 'Deskripsi untuk $title dalam konteks $className.',
        'type': classSlug,
        'materi': [
          {
            'type': p == 1 && classSlug == 'cyber_security' ? 'ppt' : 'pdf',
            'title': 'Materi ${p == 1 && classSlug == 'cyber_security' ? 'PPT' : 'PDF'}',
            'source': p == 1 && classSlug == 'cyber_security'
                ? 'assets/materi/cyber_security'
                : 'assets/materi/$classSlug/p$p.pdf',
            'isAvailable': true,
          },
          {
            'type': 'video',
            'title': 'Video Tutorial',
            'source': videoUrl,
            'isAvailable': true,
          },
          {
            'type': 'zoom',
            'title': 'Link Zoom',
            'source': isZoomAvailable
                ? 'https://zoom.us/j/1234567890?pwd=example'
                : '',
            'isAvailable': isZoomAvailable,
          },
        ],
        'attended': p <= (classId == 1 ? 3 : 1), // Simulating progress: Pertemuan 1-3 attended for class 1
        'tugas': [
          {
            'id': p,
            'title': 'Tugas $p – $title',
            'description': 'Lakukan analisis mendalam dan buatlah laporan ringkas mengenai $title dalam konteks $className tingkat lanjut.',
            'deadline': '2025-01-${10 + p} 23:59',
            'isDone': p < (classId == 1 ? 2 : 1), // Simulating progress: Tugas 1 done for class 1
            'status': p < (classId == 1 ? 2 : 1) ? 'sudah_dikumpulkan' : 'belum_dikumpulkan',
          },
        ],
        'kuis': {
          'durasiMenit': 5,
          'totalSoal': 5,
          'soal': _generateSoal(className, p),
        },
      };
    });
  }

  static List<Map<String, dynamic>> _generateSoal(String className, int p) {
    return List.generate(5, (i) {
      int sNum = i + 1;
      return {
        'id': sNum,
        'pertanyaan': 'Pertanyaan $sNum: Apa konsep utama dalam $className pertemuan ke-$p?',
        'opsi': [
          'Konsep Dasar A',
          'Konsep Lanjutan B',
          'Implementasi Praktis C',
          'Analisis Teoretis D'
        ],
        'jawaban': (i % 4), // Jawaban bervariasi
      };
    });
  }
}

