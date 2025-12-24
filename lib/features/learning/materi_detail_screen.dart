import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import 'materi_content/ui_design_content.dart';
import 'materi_content/mobile_programming_content.dart';
import 'materi_content/web_programming_content.dart';
import 'materi_content/default_content.dart';

class MateriDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? materiData;

  const MateriDetailScreen({super.key, this.materiData});

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data untuk tugas dan kuis dalam materi detail
  final List<Map<String, dynamic>> tugasDanKuis = [
    {
      'type': 'quiz',
      'title': 'Quiz Review 01',
      'desc': 'Silahkan kerjakan kuis ini...',
      'done': true,
    },
    {
      'type': 'tugas',
      'title': 'Tugas 01 – UID Android Mobile Game',
      'desc': 'Buatlah desain tampilan...',
      'done': false,
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
    final materiData = widget.materiData;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          materiData?['title'] ?? 'Detail Materi',
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
          indicatorColor: Colors.black,
          indicatorWeight: 1,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Lampiran Materi"),
            Tab(text: "Tugas dan Kuis"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLampiranTab(), _buildTugasTab()],
      ),
    );
  }

  Widget _buildLampiranTab() {
    final materiData = widget.materiData;
    final List<dynamic> lampiranList = materiData?['lampiran'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Content based on type
          _buildDynamicContent(materiData),
          const SizedBox(height: 20),
          const SizedBox(height: 20),

          // Lampiran Materi
          if (lampiranList.isNotEmpty) ...[
            Text(
              'Lampiran Materi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            // List Lampiran
            ...lampiranList.map((lampiran) {
              IconData icon;
              String type = lampiran['type'].toString().toLowerCase();

              if (type == 'pdf' || type == 'ppt') {
                icon = Icons.picture_as_pdf;
              } else if (type == 'video') {
                icon = Icons.play_circle_fill;
              } else if (type == 'zoom') {
                icon = Icons.video_call;
              } else {
                icon = Icons.link;
              }

              bool isVideo = type == 'video';
              bool hasUrl = lampiran['url'] != null &&
                  lampiran['url'].toString().isNotEmpty;

              if (isVideo && !hasUrl) {
                return const SizedBox.shrink();
              }

              return _buildLampiranItem(
                icon: icon,
                title: lampiran['title'] ?? 'Lampiran',
                subtitle: lampiran['path'] ?? lampiran['url'] ?? '',
                type: type.toUpperCase(),
                lampiranData: lampiran,
              );
            }),
          ] else ...[
            _buildEmptyState(
              'Belum ada lampiran',
              'Materi ini belum memiliki lampiran document',
            ),
          ],
        ],
      ),
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
              return _buildTugasCard(tugasData: tugas);
            },
          );
  }

  Widget _buildLampiranItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String type,
    Map<String, dynamic>? lampiranData,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          if (lampiranData != null) {
            final type = lampiranData['type'].toString().toLowerCase();
            switch (type) {
              case 'pdf':
              case 'ppt':
                Navigator.pushNamed(
                  context,
                  AppRoutes.documentViewer,
                  arguments: lampiranData,
                );
                break;
              case 'video':
                if (lampiranData['url'] != null &&
                    lampiranData['url'].toString().isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.videoPlayer,
                    arguments: lampiranData,
                  );
                }
                break;
              case 'zoom':
                if (lampiranData['url'] != null) {
                  launchUrl(Uri.parse(lampiranData['url']));
                }
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Membuka ${lampiranData['title']}')),
                );
            }
          }
        },
      ),
    );
  }

  Widget _buildTugasCard({required Map<String, dynamic> tugasData}) {
    final type = tugasData['type'];
    final title = tugasData['title'];
    final desc = tugasData['desc'];
    final done = tugasData['done'];
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
            if (type == 'quiz') {
              Navigator.pushNamed(
                context,
                AppRoutes.quizPlay,
                arguments: tugasData,
              );
            } else {
              Navigator.pushNamed(context, AppRoutes.quizDetail);
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type == 'quiz' ? 'Quiz' : 'Tugas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: done ? Colors.green : Colors.grey[300],
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
                  desc,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic>? materiData) {
    if (materiData == null) return const SizedBox();

    final type = materiData['type'];

    Widget content;
    switch (type) {
      case 'ui_ux':
        content = const UIDesignContent();
        break;
      case 'mobile_programming':
        content = const MobileProgrammingContent();
        break;
      case 'web_programming':
        content = const WebProgrammingContent();
        break;
      default:
        content = DefaultMateriContent(materiData: materiData);
        break;
    }

    return Container(
      width: double.infinity,
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
      child: content,
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
}
