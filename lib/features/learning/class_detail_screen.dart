import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

enum ContentType { lesson, quiz, assignment }

class ClassDetailScreen extends StatefulWidget {
  final String courseTitle;

  const ClassDetailScreen({
    super.key,
    this.courseTitle = "DESAIN ANTARMUKA & PENGALAMAN PENGGUNA",
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data untuk Tab Materi - UI Design
  final List<Map<String, dynamic>> uiDesignMateri = [
    {
      'id': '1',
      'badgeText': 'Pertemuan 1',
      'badgeColor': Colors.blue,
      'title': '01 - Pengantar User Interface Design',
      'description': '3 URLs, 2 Files, 3 Interactive Content',
      'isCompleted': true,
      'contentType': ContentType.lesson,
      'type': 'ui_design',
    },
    {
      'id': '2',
      'badgeText': 'Pertemuan 2',
      'badgeColor': Colors.blue,
      'title': '02 - User Experience',
      'description': '2 URLs, 1 Files',
      'isCompleted': true,
      'contentType': ContentType.lesson,
      'type': 'ui_design',
    },
    {
      'id': '3',
      'badgeText': 'Pertemuan 3',
      'badgeColor': Colors.blue,
      'title': '03 - Prototyping',
      'description': '4 URLs, 1 Files',
      'isCompleted': false,
      'contentType': ContentType.lesson,
      'type': 'ui_design',
    },
  ];

  // Data untuk Tab Materi - Mobile Programming
  final List<Map<String, dynamic>> mobileProgrammingMateri = [
    {
      'id': 'm1',
      'badgeText': 'Pertemuan 1',
      'badgeColor': Colors.orange,
      'title': '01 - Pengantar Flutter',
      'description': 'Video & Modul',
      'isCompleted': true,
      'contentType': ContentType.lesson,
      'type': 'mobile_programming',
    },
    {
      'id': 'm2',
      'badgeText': 'Pertemuan 2',
      'badgeColor': Colors.orange,
      'title': '02 - Dasar Mobile Programming',
      'description': 'Source Code & Quiz',
      'isCompleted': false,
      'contentType': ContentType.lesson,
      'type': 'mobile_programming',
    },
  ];

  // Data untuk Tab Materi - Web Programming
  final List<Map<String, dynamic>> webProgrammingMateri = [
    {
      'id': 'w1',
      'badgeText': 'Pertemuan 1',
      'badgeColor': Colors.purple,
      'title': '01 - Pengantar Web Development',
      'description': 'HTML & CSS Basics',
      'isCompleted': true,
      'contentType': ContentType.lesson,
      'type': 'web_programming',
    },
    {
      'id': 'w2',
      'badgeText': 'Pertemuan 2',
      'badgeColor': Colors.purple,
      'title': '02 - JavaScript Fundamentals',
      'description': 'Interactive Logic',
      'isCompleted': false,
      'contentType': ContentType.lesson,
      'type': 'web_programming',
    },
  ];

  List<Map<String, dynamic>> get currentMateriList {
    final title = widget.courseTitle.toLowerCase();
    if (title.contains('mobile')) {
      return mobileProgrammingMateri;
    } else if (title.contains('web')) {
      return webProgrammingMateri;
    } else {
      // Default to UI Design (or logic for specific title)
      return uiDesignMateri;
    }
  }

  // Data untuk Tab Tugas dan Kuis
  final List<Map<String, dynamic>> tugasDanKuis = [
    {
      'id': 'quiz1',
      'type': 'quiz',
      'badgeText': 'Quiz',
      'badgeColor': Colors.blue,
      'title': 'Quiz Review 01',
      'desc': 'Silahkan kerjakan kuis ini...',
      'description': 'Tenggat Waktu: 20 Februari 2021 23:59 WIB',
      'done': true,
      'contentType': ContentType.quiz,
    },
    {
      'id': 'quiz2',
      'type': 'quiz',
      'badgeText': 'Quiz',
      'badgeColor': Colors.purple,
      'title': 'Quiz Review 02 - Flutter Basic',
      'desc': 'Tes pengetahuan dasar Flutter...',
      'description': 'Tenggat Waktu: 25 Februari 2021 23:59 WIB',
      'done': false,
      'contentType': ContentType.quiz,
    },
    {
      'id': 'tugas1',
      'type': 'tugas',
      'badgeText': 'Tugas',
      'badgeColor': Colors.blue,
      'title': 'Tugas 01 – UID Android Mobile Game',
      'desc': 'Buatlah desain tampilan...',
      'description': 'Tenggat Waktu: 26 Februari 2021 23:59 WIB',
      'done': false,
      'contentType': ContentType.assignment,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background: abu-abu muda
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor, // AppBar warna merah
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.courseTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              "D4SM-42-03 [ADY]",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black, // Indikator garis hitam tipis
          indicatorWeight: 1, // Tipis
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Materi"),
            Tab(text: "Tugas Dan Kuis"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMateriTab(), _buildTugasTab()],
      ),
    );
  }

  Widget _buildMateriTab() {
    final materiList = currentMateriList;

    return materiList.isEmpty
        ? _buildEmptyState(
            'Belum ada materi tersedia',
            'Materi akan muncul di sini ketika sudah tersedia',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: materiList.length,
            itemBuilder: (context, index) {
              final materi = materiList[index];
              return _buildContentCard(
                badgeText: materi['badgeText'],
                badgeColor: materi['badgeColor'],
                title: materi['title'],
                description: materi['description'],
                isCompleted: materi['isCompleted'],
                contentType: materi['contentType'],
                data: materi,
              );
            },
          );
  }

  Widget _buildTugasTab() {
    return tugasDanKuis.isEmpty
        ? _buildEmptyState(
            'Tidak Ada Tugas Dan Kuis',
            'Tugas dan kuis akan muncul di sini',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tugasDanKuis.length,
            itemBuilder: (context, index) {
              final tugas = tugasDanKuis[index];
              return _buildContentCard(
                badgeText: tugas['badgeText'],
                badgeColor: tugas['badgeColor'],
                title: tugas['title'],
                description: tugas['description'],
                isCompleted: tugas['done'],
                isTask: true,
                contentType: tugas['contentType'],
                data: tugas,
              );
            },
          );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard({
    required String badgeText,
    required Color badgeColor,
    required String title,
    required String description,
    required bool isCompleted,
    bool isTask = false,
    required ContentType contentType,
    Map<String, dynamic>? data,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            switch (contentType) {
              case ContentType.lesson:
                // Navigate to Materi Detail with data
                Navigator.pushNamed(context, '/materi-detail', arguments: data);
                break;
              case ContentType.quiz:
                Navigator.pushNamed(context, '/quiz-play', arguments: data);
                break;
              case ContentType.assignment:
                Navigator.pushNamed(context, AppRoutes.quizDetail);
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: isCompleted ? Colors.green : Colors.grey[300],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isTask ? Colors.redAccent : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
