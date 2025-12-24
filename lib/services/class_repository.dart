class ClassRepository {
  static final List<Map<String, dynamic>> classes = [
    {
      'id': 1,
      'title': 'Desain Antarmuka & UI/UX',
      'type': 'ui_ux',
      'materi': [
        {
          'id': 1,
          'title': 'Pertemuan 1 – Pengantar UI/UX',
          'description': 'Pengenalan konsep UI/UX design.',
          'lampiran': [
            {
              'title': 'Video Tutorial UI/UX',
              'type': 'video',
              'platform': 'youtube',
              'url': 'https://youtu.be/fZXfF6RyNpU',
            },
          ],
        },
      ],
    },
    {
      'id': 2,
      'title': 'Mobile Programming',
      'type': 'mobile_programming',
      'materi': [
        {
          'id': 1,
          'title': 'Pertemuan 1 – Dasar Mobile Programming',
          'description': 'Pengenalan pengembangan aplikasi mobile.',
          'lampiran': [
            {
              'title': 'Video Tutorial Mobile Programming',
              'type': 'video',
              'platform': 'youtube',
              'url': 'https://youtu.be/1ukSR1GRtMU',
            },
          ],
        },
      ],
    },
    {
      'id': 3,
      'title': 'Web Programming',
      'type': 'web_programming',
      'materi': [
        {
          'id': 1,
          'title': 'Pertemuan 1 - Pengantar Web Development',
          'description': 'Dasar-dasar HTML & CSS.',
          'lampiran': [
            {
              'title': 'PDF Web Intro',
              'type': 'pdf',
              'source': 'asset',
              'path': 'assets/materi/web/web_p1.pdf',
            },
          ],
        },
      ],
    },
  ];
}
