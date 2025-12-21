import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

class MyClassesScreen extends StatelessWidget {
  const MyClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kelas Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildVerticalCourseCard(
            context,
            title: 'UI/UX Design',
            instructor: 'Dedi Triguna, S.T., M.Kom',
            progress: 0.7,
            color: Colors.orange[100]!,
          ),
          _buildVerticalCourseCard(
            context,
            title: 'Mobile Programming',
            instructor: 'Haikal Abdillah',
            progress: 0.3,
            color: Colors.blue[100]!,
          ),
          _buildVerticalCourseCard(
            context,
            title: 'Web Development',
            instructor: 'Google',
            progress: 0.1,
            color: Colors.green[100]!,
          ),
          _buildVerticalCourseCard(
            context,
            title: 'Data Science',
            instructor: 'Andrew Ng',
            progress: 0.0,
            color: Colors.purple[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCourseCard(
    BuildContext context, {
    required String title,
    required String instructor,
    required double progress,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.classDetail, arguments: title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.white54,
              ), // Placeholder
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instructor,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            color: AppTheme.primaryColor,
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
