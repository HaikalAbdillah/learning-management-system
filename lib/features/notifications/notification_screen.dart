import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _NotificationItem(
            isQuiz: false,
            text: "Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)",
            time: "3 Hari 9 Jam Yang Lalu",
          ),
          _NotificationItem(
            isQuiz: true,
            text: "Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)",
            time: "3 Hari 9 Jam Yang Lalu",
          ),
          _NotificationItem(
            isQuiz: false,
            text: "Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)",
            time: "3 Hari 9 Jam Yang Lalu",
          ),
          _NotificationItem(
            isQuiz: true,
            text: "Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)",
            time: "3 Hari 9 Jam Yang Lalu",
          ),
          _NotificationItem(
            isQuiz: false,
            text: "Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)",
            time: "3 Hari 9 Jam Yang Lalu",
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final bool isQuiz;
  final String text;
  final String time;

  const _NotificationItem({
    required this.isQuiz,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: isQuiz
                ? const Icon(Icons.question_answer_outlined, size: 28, color: Colors.black) // Quiz Bubble looking
                : const Icon(Icons.description_outlined, size: 28, color: Colors.black), // Document looking
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
