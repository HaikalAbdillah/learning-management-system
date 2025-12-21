import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isIndonesian = true; // Default ID

  // Content Strings
  final String _contentID = '''
Akses hanya untuk Dosen dan Mahasiswa Telkom University.

Login menggunakan Akun Microsoft Office 365
dengan mengikuti petunjuk berikut:

Username (Akun iGracias) ditambahkan "@2201.uim.ac.id"
Password (Akun iGracias) pada kolom Password.

Kegagalan yang terjadi pada Autentikasi disebabkan oleh
Anda belum mengubah Password Anda menjadi "Strong Password".
Pastikan Anda telah melakukan perubahan Password di iGracias.

Informasi lebih lanjut dapat menghubungi Layanan CeLOE Helpdesk:
mail : @uim.ac.id
whatsapp : +62 817-7993-6760
''';

  final String _contentEN = '''
Access restricted only for Lecturer and Student of Telkom University.

Login only using your Microsoft Office 365 Account
by following these format:

Username (iGracias Account) followed with "@2201.uim.ac.id"
Password (SSO / iGracias Account) on Password Field.

Failure upon Authentication could be possibly you
have not yet change your password into "Strong Password".
Make sure to change your password only in iGracias.

For further Information, please contact CeLOE Service Helpdesk:
mail : @uim.ac.id
whatsapp : +62 817-7993-6760
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Contrast background
      appBar: AppBar(
        title: const Text("Bantuan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Language Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageButton("ID", true),
                        _buildLanguageButton("EN", false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isIndonesian ? _contentID : _contentEN,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String text, bool isId) {
    final bool isSelected = isIndonesian == isId;
    return GestureDetector(
      onTap: () {
        setState(() {
          isIndonesian = isId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
