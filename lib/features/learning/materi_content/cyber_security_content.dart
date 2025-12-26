import 'package:flutter/material.dart';
import '../../../core/utils/string_utils.dart';

class CyberSecurityContent extends StatelessWidget {
  final Map<String, dynamic>? materiData;

  const CyberSecurityContent({super.key, this.materiData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(safeString(materiData?['title'], 'Cyber Security Overview')),
          const SizedBox(height: 10),
          Text(
            safeString(materiData?['description'], 
            'Keamanan siber adalah praktik melindungi sistem, jaringan, dan program dari serangan digital.'),
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Konsep Utama'),
          const SizedBox(height: 10),
          _buildConceptItem(
            '1. Kerahasiaan (Confidentiality)',
            'Hanya orang yang berwenang yang dapat mengakses data.',
          ),
          _buildConceptItem(
            '2. Integritas (Integrity)',
            'Informasi tetap akurat dan tidak diubah tanpa izin.',
          ),
          _buildConceptItem(
            '3. Ketersediaan (Availability)',
            'Sistem dan data tersedia saat dibutuhkan.',
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withAlpha(77),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.security, size: 40, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  'Cyber Security Essentials',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Fokus pada perlindungan aset digital dan data sensitif.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.green[800]),
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

  Widget _buildConceptItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, size: 20, color: Colors.blue),
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
