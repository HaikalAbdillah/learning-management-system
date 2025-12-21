import 'package:flutter/material.dart';

class WebProgrammingContent extends StatelessWidget {
  const WebProgrammingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pengantar Web Development'),
          const SizedBox(height: 10),
          const Text(
            'Web Development adalah proses membangun dan memelihara situs web. Ini mencakup desain web, penerbitan web, pemrograman web, dan manajemen basis data.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Teknologi Utama'),
          const SizedBox(height: 10),
          _buildTechItem('HTML', 'Struktur halaman web', Colors.orange),
          _buildTechItem('CSS', 'Desain dan tata letak', Colors.blue),
          _buildTechItem('JavaScript', 'Logika Interaktif', Colors.yellow[700]!),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.language, size: 40, color: Colors.blue[800]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Stack Web',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Frontend + Backend',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTechItem(String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              title[0],
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
