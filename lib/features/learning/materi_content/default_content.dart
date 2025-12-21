import 'package:flutter/material.dart';

class DefaultMateriContent extends StatelessWidget {
  final Map<String, dynamic>? materiData;

  const DefaultMateriContent({super.key, this.materiData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            materiData?['title'] ?? 'Judul Materi',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            materiData?['description'] ?? 'Deskripsi materi akan muncul di sini.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Icon(Icons.article_outlined, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 10),
                Text(
                  "Konten belum tersedia untuk tipe ini.",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
