import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../services/class_repository.dart';

enum ContentType { lesson, quiz, assignment }

class ClassDetailScreen extends StatefulWidget {
  final int classId;

  const ClassDetailScreen({super.key, required this.classId});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Map<String, dynamic> classData;
  List<Map<String, dynamic>> materiList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch data based on ID
    try {
      classData = ClassRepository.classes.firstWhere(
        (e) => e['id'] == widget.classId,
      );
      materiList = List<Map<String, dynamic>>.from(classData['materi'] ?? []);
    } catch (e) {
      // Fallback or error handling
      classData = {'title': 'Kelas Tidak Ditemukan'};
      materiList = [];
    }
  }


  // InitState removed here as it is moved up

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
        title: Text(
          classData['title'] ?? "Course",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
    // materiList is now populated in initState

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
              final data = Map<String, dynamic>.from(materi);
              data['classType'] = classData['type'];
              return _buildContentCard(
                badgeText: 'Pertemuan ${materi['id']}',
                badgeColor: _getBadgeColor(classData['type']),
                title: materi['title'],
                description: materi['description'],
                isCompleted: false, // Default to false
                contentType: ContentType.lesson,
                data: data,
              );
            },
          );
  }

  Color _getBadgeColor(String? type) {
    switch (type) {
      case 'ui_ux':
        return Colors.red;
      case 'mobile_programming':
        return Colors.blue;
      case 'web_programming':
        return Colors.purple;
      case 'cyber_security':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTugasTab() {
    // Collect all assignments and quizzes from all meetings
    final List<Map<String, dynamic>> aggregatedItems = [];

    for (var materi in materiList) {
      // Assignments
      final List<dynamic> assignmentList = materi['tugas'] ?? [];
      for (var tugas in assignmentList) {
        aggregatedItems.add({
          'badgeText': 'Tugas',
          'badgeColor': Colors.blue,
          'title': tugas['title'],
          'description': 'Tenggat Waktu: ${tugas['deadline']}',
          'done': tugas['isDone'],
          'contentType': ContentType.assignment,
          'materi': materi,
        });
      }

      // Quizzes
      final List<dynamic> quizList = materi['kuis'] ?? [];
      for (var quiz in quizList) {
        aggregatedItems.add({
          'badgeText': 'Quiz',
          'badgeColor': Colors.purple,
          'title': quiz['title'],
          'description': quiz['desc'] ?? 'Kerjakan kuis ini',
          'done': quiz['isDone'] ?? false,
          'contentType': ContentType.quiz,
          'materi': materi,
        });
      }
    }

    return aggregatedItems.isEmpty
        ? _buildEmptyState(
            'Tidak Ada Tugas Dan Kuis',
            'Tugas dan kuis akan muncul di sini',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: aggregatedItems.length,
            itemBuilder: (context, index) {
              final item = aggregatedItems[index];
              return _buildContentCard(
                badgeText: item['badgeText'],
                badgeColor: item['badgeColor'],
                title: item['title'],
                description: item['description'],
                isCompleted: item['done'],
                isTask: item['contentType'] == ContentType.assignment,
                contentType: item['contentType'],
                data: item,
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
                Navigator.pushNamed(context, AppRoutes.quiz, arguments: data);
                break;
              case ContentType.assignment:
                Navigator.pushNamed(context, AppRoutes.tugas, arguments: data);
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
