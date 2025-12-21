import 'package:flutter/material.dart';

class UIDesignContent extends StatelessWidget {
  const UIDesignContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pengantar UI Design'),
          const SizedBox(height: 10),
          const Text(
            'User Interface (UI) Design adalah proses yang digunakan desainer untuk membuat tampilan dalam perangkat lunak atau perangkat terkomputerisasi, dengan fokus pada tampilan atau gaya.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Prinsip Desain Utama'),
          const SizedBox(height: 10),
          _buildPrincipleItem(
            '1. Kejelasan (Clarity)',
            'Desain harus mudah dipahami.',
          ),
          _buildPrincipleItem(
            '2. Konsistensi (Consistency)',
            'Elemen desain harus seragam.',
          ),
          _buildPrincipleItem(
            '3. Responsivitas (Responsiveness)',
            'Desain harus bekerja di berbagai ukuran layar.',
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25), // 0.1 * 255 ≈ 25
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withAlpha(77),
              ), // 0.3 * 255 ≈ 77
            ),
            child: Column(
              children: [
                const Icon(Icons.design_services, size: 40, color: Colors.blue),
                const SizedBox(height: 10),
                const Text(
                  'Ilustrasi UI Design',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Fokus pada estetika dan kemudahan penggunaan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.blue[800]),
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

  Widget _buildPrincipleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
