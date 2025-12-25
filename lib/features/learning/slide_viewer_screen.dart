import 'package:flutter/material.dart';

class SlideViewerScreen extends StatefulWidget {
  const SlideViewerScreen({super.key});

  @override
  State<SlideViewerScreen> createState() => _SlideViewerScreenState();
}

class _SlideViewerScreenState extends State<SlideViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> lampiran =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String path = lampiran['path'] ?? '';
    final String title = lampiran['title'] ?? 'Slide Materi';
    final List<String> slides = List<String>.from(lampiran['slides'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFC62828), // Deep red for LMS theme
        foregroundColor: Colors.white,
      ),
      body: slides.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.slideshow_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Materi Belum Tersedia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Slide untuk pertemuan ini sedang disiapkan.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: slides.length,
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
                            '$path${slides[index]}',
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
                        const SizedBox(height: 20),
                        Text(
                          'Slide ${index + 1} / ${slides.length}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Total: ${slides.length} Slide',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
