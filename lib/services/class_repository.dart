class ClassRepository {
  static final List<Map<String, dynamic>> classes = [
    {
      'id': 1,
      'title': 'Desain Antarmuka & UI/UX',
      'type': 'ui_ux',
      'materi': List.generate(7, (index) {
        final p = index + 1;
        return {
          'id': p,
          'title': 'Pertemuan $p – Pengantar UI/UX',
          'description': 'Materi pertemuan ke-$p untuk Desain Antarmuka & UI/UX.',
          'lampiran': p == 1 ? [
            {
              'title': 'Video Tutorial UI/UX',
              'type': 'video',
              'platform': 'youtube',
              'url': 'https://youtu.be/fZXfF6RyNpU',
            },
          ] : [],
          'tugas': p == 1 ? [
            {
              'id': 1,
              'title': 'Tugas 01 – UID Android Mobile Game',
              'deadline': '26 Februari 2021, 23:59 WIB',
              'status': 'Belum Dikerjakan',
              'isDone': false,
            }
          ] : [],
          'kuis': p == 1 ? [
            {
              'id': 1,
              'title': 'Quiz Review 01',
              'desc': 'Silahkan kerjakan kuis ini...',
              'isDone': true,
            }
          ] : [],
        };
      }),
    },
    {
      'id': 2,
      'title': 'Mobile Programming',
      'type': 'mobile_programming',
      'materi': List.generate(7, (index) {
        final p = index + 1;
        return {
          'id': p,
          'title': 'Pertemuan $p – Dasar Mobile Programming',
          'description': 'Materi pertemuan ke-$p untuk Mobile Programming.',
          'lampiran': p == 1 ? [
            {
              'title': 'Video Tutorial Mobile Programming',
              'type': 'video',
              'platform': 'youtube',
              'url': 'https://youtu.be/1ukSR1GRtMU',
            },
          ] : [],
          'tugas': [],
          'kuis': [],
        };
      }),
    },
    {
      'id': 3,
      'title': 'Cyber Security',
      'code': 'CS-401',
      'type': 'cyber_security',
      'instructor': 'Dosen Cyber Security',
      'materi': List.generate(7, (index) {
        final p = index + 1;
        return {
          'id': p,
          'title': 'Pertemuan $p – Cyber Security',
          'description': 'Materi pertemuan ke-$p untuk Cyber Security.',
          'lampiran': [
            {
              'title': 'Slide Materi Pertemuan $p',
              'type': 'ppt',
              'source': 'asset',
              'path': 'assets/materi/cyber/pertemuan$p/',
              'slides': p == 1 ? [
                'pertemuan pertama cyber_page-0001.jpg',
                'pertemuan pertama cyber_page-0002.jpg',
                'pertemuan pertama cyber_page-0003.jpg',
                'pertemuan pertama cyber_page-0004.jpg',
                'pertemuan pertama cyber_page-0005.jpg',
                'pertemuan pertama cyber_page-0006.jpg',
                'pertemuan pertama cyber_page-0007.jpg',
              ] : [],
            },
          ],
          'tugas': [],
          'kuis': [],
        };
      }),
    },
    {
      'id': 4,
      'title': 'Web Programming',
      'type': 'web_programming',
      'materi': List.generate(7, (index) {
        final p = index + 1;
        return {
          'id': p,
          'title': 'Pertemuan $p - Pengantar Web Development',
          'description': 'Materi pertemuan ke-$p untuk Web Programming.',
          'lampiran': p == 1 ? [
            {
              'title': 'PDF Web Intro',
              'type': 'pdf',
              'source': 'asset',
              'path': 'assets/materi/web/web_p1.pdf',
            },
          ] : [],
          'tugas': [],
          'kuis': [],
        };
      }),
    },
  ];
}
