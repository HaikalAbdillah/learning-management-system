import 'package:flutter/material.dart';

class QuizDetailScreen extends StatefulWidget {
  const QuizDetailScreen({super.key});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _hasData = true; // Toggle this to test empty state

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Konsep User Interface Design",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Section
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "Mata kuliah ini membahas prinsip dan teknik desain antarmuka pengguna, termasuk usability, aksesibilitas, dan prototyping.",
                  style: TextStyle(color: Colors.black87, height: 1.5),
                ),
              ],
            ),
          ),

          // TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            tabs: const [
              Tab(text: "Lampiran Materi"),
              Tab(text: "Tugas dan Kuis"),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildLampiranTab(), _buildTugasTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLampiranTab() {
    return const Center(
      child: Text(
        "Belum ada lampiran materi",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildTugasTab() {
    if (!_hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Tidak Ada Tugas Dan Kuis Hari Ini",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTaskCard(
          isQuiz: true,
          title: "Quiz Review 01",
          description: "Kerjakan quiz berikut dengan teliti.",
          isCompleted: true,
        ),
        _buildTaskCard(
          isQuiz: false,
          title: "Tugas 01 - UID Android Mobile Game",
          description: "Buatlah desain UID untuk game mobile sederhana.",
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required bool isQuiz,
    required String title,
    required String description,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isQuiz
                    ? Colors.blue[50]
                    : Colors
                          .orange[50], // Different colors for visual distinction
                shape: BoxShape.circle,
              ),
              child: Icon(
                isQuiz ? Icons.quiz : Icons.assignment,
                color: isQuiz ? Colors.blue : Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status Icon
            Icon(
              Icons.check_circle,
              color: isCompleted ? Colors.green : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
