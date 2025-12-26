import 'package:flutter/material.dart';

class SlideViewerScreen extends StatefulWidget {
  const SlideViewerScreen({super.key});

  @override
  State<SlideViewerScreen> createState() => _SlideViewerScreenState();
}

class _SlideViewerScreenState extends State<SlideViewerScreen> {
  @override
  Widget build(BuildContext context) {
    // LANGKAH 1 — PERBAIKI PENGAMBILAN ARGUMENT
    final args = ModalRoute.of(context)?.settings.arguments;

    final String folderPath =
        (args is Map<String, dynamic> && args['path'] is String)
            ? args['path']
            : '';

    final String title =
        (args is Map<String, dynamic> && args['title'] is String)
            ? args['title']
            : 'Slide Materi';

    // LANGKAH 2 — HANDLE FOLDER KOSONG (INI WAJIB)
    if (folderPath.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFFC62828),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Slide materi belum tersedia')),
      );
    }

    // LANGKAH 3 — DAFTAR SLIDE HARUS AMAN
    final List<dynamic> slidesRaw =
        (args is Map<String, dynamic> && args['slides'] is List)
            ? args['slides']
            : [];

    final List<String> slides = slidesRaw.map((s) => s.toString()).toList();

    // FILTER sebelum render
    final validSlides = slides.where((s) => s.isNotEmpty).toList();

    if (validSlides.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color(0xFFC62828),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Tidak ada slide pada pertemuan ini')),
      );
    }

    // LANGKAH 4 — RENDER SLIDE DENGAN AMAN
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: validSlides.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  '$folderPath/${validSlides[index]}',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Halaman ${index + 1} / ${validSlides.length}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
