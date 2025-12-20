import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../features/learning/quiz_screen.dart';
import 'lesson_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseTitle;

  const CourseDetailScreen({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(courseTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Container(
                    color: AppTheme.secondaryColor, // Placeholder for Image
                    child: Center(child: Icon(Icons.class_, size: 50, color: Colors.white24)),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppTheme.primaryColor,
                    tabs: [
                      Tab(text: "Overview"),
                      Tab(text: "Kurikulum"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildOverviewTab(),
              _buildCurriculumTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8),
        Text(
          "Mata kuliah ini mempelajari tentang prinsip-prinsip desain antarmuka pengguna (UI) dan pengalaman pengguna (UX). Mahasiswa akan belajar menggunakan tools seperti Figma.",
          style: TextStyle(color: Colors.grey, height: 1.5),
        ),
        SizedBox(height: 20),
        Text("Pengajar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: Colors.grey),
          title: Text("Dedi Triguna"),
          subtitle: Text("Dosen Telkom University"),
        ),
      ],
    );
  }

  Widget _buildCurriculumTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text("Modul ${index + 1}: Pengenalan", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("3 Lessons • 45 Mins"),
            children: [
               ListTile(
                 leading: const Icon(Icons.play_circle_outline, color: AppTheme.primaryColor),
                 title: const Text("1.1 Apa itu UI/UX?"),
                 trailing: Icon(Icons.check_circle, color: Colors.green, size: 20), // Completed
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonScreen()));
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.play_circle_outline, color: AppTheme.primaryColor),
                 title: const Text("1.2 Sejarah Design"),
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const LessonScreen()));
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.quiz_outlined, color: Colors.orange),
                 title: const Text("Quiz Modul 1"),
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
                 },
               ),
            ],
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
