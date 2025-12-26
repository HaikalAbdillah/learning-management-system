import 'package:flutter/material.dart';

class MobileProgrammingContent extends StatelessWidget {
  const MobileProgrammingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Dasar Mobile Programming'),
          const SizedBox(height: 10),
          const Text(
            'Mobile Programming adalah pembuatan aplikasi untuk perangkat mobile seperti smartphone dan tablet.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Topik Pembahasan'),
          const SizedBox(height: 10),
          _buildTopicItem('1. Pengenalan Flutter'),
          _buildTopicItem('2. Widget Dasar (Stateless & Stateful)'),
          _buildTopicItem('3. Manajemen State'),
          const SizedBox(height: 20),
          _buildSectionTitle('Contoh Code - Hello World'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'void main() {\n  runApp(\n    MaterialApp(\n      home: Text("Hello World"),\n    ),\n  );\n}',
              style: TextStyle(
                fontFamily: 'Courier New',
                color: Colors.lightGreenAccent,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Action simulate
                // Removed: ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Membuka Live Demo...')),
                // );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Lihat Contoh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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

  Widget _buildTopicItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.code, size: 20, color: Colors.orange),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
