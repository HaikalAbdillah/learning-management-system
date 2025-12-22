import 'package:flutter/material.dart';

class AnnouncementListScreen extends StatelessWidget {
  const AnnouncementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pengumuman',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildAnnouncementItem(
            context,
            title: "Maintenance Pra UAS Semester Genap 2020/2021",
            author: "By Admin Celoe - Rabu, 2 Juni 2021, 10:45",
          ),
          _buildAnnouncementItem(
            context,
            title: "Pengumuman Maintance",
            author: "By Admin Celoe - Senin, 11 Januari 2021, 7:52",
          ),
          _buildAnnouncementItem(
            context,
            title: "Maintenance Pra UAS Semeter Ganjil 2020/2021",
            author: "By Admin Celoe - Minggu, 10 Januari 2021, 9:30",
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(
    BuildContext context, {
    required String title,
    required String author,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/announcement-detail');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.campaign, size: 30, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
