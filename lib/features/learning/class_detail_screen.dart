import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../services/class_repository.dart';
import '../../core/utils/string_utils.dart';

enum ContentType { lesson, quiz, assignment }

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({super.key});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> classData;
  List<Map<String, dynamic>> materiList = [];
  bool isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final classId = ModalRoute.of(context)?.settings.arguments as int? ?? 1;

    try {
      classData = ClassRepository.classes.firstWhere((e) => e['id'] == classId);
      materiList = List<Map<String, dynamic>>.from(classData['materi'] ?? []);
    } catch (e) {
      classData = {'title': 'Kelas Tidak Ditemukan'};
      materiList = [];
    }

    setState(() {
      isLoading = false;
    });
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          safeString(classData['title'], "Course"),
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
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Materi"),
            Tab(text: "Tugas & Kuis"),
            Tab(text: "Absensi"),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [_buildMateriTab(), _buildTugasTab(), _buildAbsensiTab()],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Memuat Kelas...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat detail kelas...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriTab() {
    if (materiList.isEmpty) {
      return _buildEmptyState(
        'Belum ada materi tersedia',
        'Materi akan muncul di sini ketika sudah tersedia',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: materiList.length,
      itemBuilder: (context, index) {
        final materi = materiList[index];
        return _buildContentCard(
          badgeText: 'Pertemuan ${materi['id']}',
          badgeColor: _getBadgeColor(classData['type']),
          title: safeString(materi['title'], 'Judul Materi'),
          description: 'Klik untuk melihat materi pertemuan',
          isCompleted: false,
          contentType: ContentType.lesson,
          data: materi,
        );
      },
    );
  }

  Widget _buildTugasTab() {
    final List<Map<String, dynamic>> aggregatedItems = [];

    for (var materi in materiList) {
      // Assignments
      final List<dynamic> assignments = materi['tugas'] ?? [];
      for (var task in assignments) {
        aggregatedItems.add({
          'badgeText': 'Tugas',
          'badgeColor': Colors.blue,
          'title': safeString(task['title'], 'Tugas'),
          'description': 'Deadline: ${safeString(task['deadline'], '-')}',
          'done': task['isDone'] ?? false,
          'contentType': ContentType.assignment,
          'data': task,
        });
      }

      // Quiz
      final kuis = materi['kuis'];
      if (kuis != null) {
        aggregatedItems.add({
          'badgeText': 'Quiz',
          'badgeColor': Colors.purple,
          'title': safeString(kuis['title'], 'Kuis Pertemuan ${materi['id']}'),
          'description':
              '${kuis['totalSoal'] ?? 0} Soal • ${kuis['durasiMenit'] ?? 0} Menit',
          'done': kuis['isDone'] ?? false,
          'contentType': ContentType.quiz,
          'data': kuis,
        });
      }
    }

    if (aggregatedItems.isEmpty) {
      return _buildEmptyState(
        'Tidak Ada Tugas Dan Kuis',
        'Tugas dan kuis akan muncul di sini',
      );
    }

    return ListView.builder(
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
          contentType: item['contentType'],
          data: item['data'],
        );
      },
    );
  }

  Widget _buildContentCard({
    required String badgeText,
    required Color badgeColor,
    required String title,
    required String description,
    required bool isCompleted,
    required ContentType contentType,
    required Map<String, dynamic> data,
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
          onTap: () async {
            // Haptic feedback
            HapticFeedback.lightImpact();

            // Check if context is still valid
            if (!mounted) return;

            await Future.delayed(const Duration(milliseconds: 200));

            // Check again after delay
            if (!mounted) return;

            switch (contentType) {
              case ContentType.lesson:
                Navigator.pushNamed(context, AppRoutes.materi, arguments: data);
                break;
              case ContentType.assignment:
                Navigator.pushNamed(
                  context,
                  AppRoutes.assignmentDetail,
                  arguments: data,
                );
                break;
              case ContentType.quiz:
                Navigator.pushNamed(
                  context,
                  AppRoutes.quizPlay,
                  arguments: data,
                );
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
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText.toUpperCase(),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
      ),
    );
  }

  Widget _buildAbsensiTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: materiList.length,
      itemBuilder: (context, index) {
        final meeting = materiList[index];
        final bool isAttended = meeting['attended'] ?? false;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isAttended ? Colors.green : Colors.orange).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAttended
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isAttended ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pertemuan ${meeting['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isAttended ? 'Sudah Absen' : 'Belum Absen',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: isAttended
                    ? null
                    : () {
                        setState(() {
                          materiList[index]['attended'] = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Absensi Pertemuan ${meeting['id']} berhasil',
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAttended
                      ? Colors.grey
                      : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isAttended ? 'Lengkap' : 'Hadir'),
              ),
            ],
          ),
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
}
