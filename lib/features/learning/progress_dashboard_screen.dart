import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../config/app_theme.dart';
import '../../models/progress.dart';
import '../../services/progress_service.dart';

class ProgressDashboardScreen extends StatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  State<ProgressDashboardScreen> createState() =>
      _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends State<ProgressDashboardScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic> progressSummary = {};
  LearningAnalytics? analytics;
  List<Achievement> achievements = [];
  bool isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _loadData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final summary = await ProgressService().getProgressSummary();
      final analyticsData = await ProgressService().getLearningAnalytics();
      final achievementsData = await ProgressService().getUserAchievements();

      setState(() {
        progressSummary = summary;
        analytics = analyticsData;
        achievements = achievementsData;
        isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      Logger(
        'ProgressDashboardScreen',
      ).severe('Error loading progress data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Progress & Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Progress Card
              _buildOverallProgressCard(),
              const SizedBox(height: 24),

              // Quick Stats Grid
              _buildQuickStatsGrid(),
              const SizedBox(height: 24),

              // Learning Analytics
              if (analytics != null) ...[
                _buildLearningAnalyticsSection(),
                const SizedBox(height: 24),
              ],

              // Achievements
              _buildAchievementsSection(),
              const SizedBox(height: 24),

              // Recent Activity
              _buildRecentActivitySection(),
            ],
          ),
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
          'Progress & Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
              'Memuat data progress...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    final overallProgress =
        (progressSummary['overallProgress'] ?? 0.0) as double;
    final completedMaterials = progressSummary['completedMaterials'] ?? 0;
    final totalMaterials = progressSummary['totalMaterials'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress Keseluruhan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(overallProgress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor: Colors.white.withAlpha(76),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedMaterials dari $totalMaterials materi selesai',
                style: TextStyle(
                  color: Colors.white.withAlpha(229),
                  fontSize: 14,
                ),
              ),
              Icon(
                overallProgress >= 1.0 ? Icons.emoji_events : Icons.trending_up,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    final totalStudyTime =
        progressSummary['totalStudyTime'] as Duration? ?? Duration.zero;
    final averageQuizScore = progressSummary['averageQuizScore'] ?? 0.0;
    final unlockedAchievements = progressSummary['unlockedAchievements'] ?? 0;
    final totalAchievements = progressSummary['totalAchievements'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard(
              'Total Waktu Belajar',
              _formatDuration(totalStudyTime),
              Icons.access_time,
              Colors.blue,
            ),
            _buildStatCard(
              'Rata-rata Quiz',
              '${averageQuizScore.round()}%',
              Icons.quiz,
              Colors.green,
            ),
            _buildStatCard(
              'Achievement',
              '$unlockedAchievements/$totalAchievements',
              Icons.emoji_events,
              Colors.orange,
            ),
            _buildStatCard(
              'Materi Selesai',
              '${progressSummary['completedMaterials'] ?? 0}',
              Icons.check_circle,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLearningAnalyticsSection() {
    if (analytics == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Analytics Pembelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAnalyticsRow('Total Sesi', '${analytics!.sessionsCount}'),
              const Divider(),
              _buildAnalyticsRow(
                'Rata-rata per Sesi',
                '${analytics!.averageSessionDuration.round()} menit',
              ),
              const Divider(),
              _buildAnalyticsRow(
                'Materi PDF/PPT',
                '${analytics!.materialTypeUsage['pdf'] ?? 0 + (analytics!.materialTypeUsage['ppt'] ?? 0)}',
              ),
              const Divider(),
              _buildAnalyticsRow(
                'Video Tutorial',
                '${analytics!.materialTypeUsage['video'] ?? 0}',
              ),
              const Divider(),
              _buildAnalyticsRow(
                'Sesi Zoom',
                '${analytics!.materialTypeUsage['zoom'] ?? 0}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    final unlockedAchievements = achievements
        .where((a) => a.isUnlocked)
        .toList();
    final lockedAchievements = achievements
        .where((a) => !a.isUnlocked)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '${unlockedAchievements.length}/${achievements.length}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (unlockedAchievements.isNotEmpty) ...[
          const Text(
            'Terkunci',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: unlockedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementItem(unlockedAchievements[index], true);
              },
            ),
          ),
        ],
        if (lockedAchievements.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Terkunci',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lockedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementItem(lockedAchievements[index], false);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAchievementItem(Achievement achievement, bool isUnlocked) {
    return Container(
      width: 70,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.amber[100] : Colors.grey[100],
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? Colors.amber : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Icon(
              _getAchievementIcon(achievement.iconName),
              color: isUnlocked ? Colors.amber[700] : Colors.grey[400],
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              achievement.title,
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? Colors.black87 : Colors.grey[500],
                fontWeight: isUnlocked ? FontWeight.w500 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Materi baru tersedia',
                'Periksa pembaruan kursus terbaru',
                Icons.new_releases,
                Colors.blue,
              ),
              const Divider(),
              _buildActivityItem(
                'Quiz selesai',
                'Nilai Anda: 85%',
                Icons.quiz,
                Colors.green,
              ),
              const Divider(),
              _buildActivityItem(
                'Tugas dikumpulkan',
                'Tugas Mobile Programming',
                Icons.assignment_turned_in,
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
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
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      ],
    );
  }

  IconData _getAchievementIcon(String iconName) {
    switch (iconName) {
      case 'login':
        return Icons.login;
      case 'book':
        return Icons.book;
      case 'calendar':
        return Icons.calendar_today;
      case 'trophy':
        return Icons.emoji_events;
      case 'graduation_cap':
        return Icons.school;
      case 'clock':
        return Icons.access_time;
      default:
        return Icons.star;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}j ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
