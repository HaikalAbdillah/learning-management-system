import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/utils/string_utils.dart';

class TugasScreen extends StatelessWidget {
  const TugasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> data = (args is Map<String, dynamic>) ? args : {};

    // We assume the data passed is either the 'materi' object or a specific assignment.
    // In ClassDetailScreen, we pass 'materi' for lessons, but 'data' (assignment object) for assignments.
    // Let's handle both.

    final List<dynamic> assignments = data.containsKey('tugas')
        ? data['tugas']
        : [data]; // If it's a single task, wrap in list

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.uploadAssignment);
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Unggah Tugas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Expanded(
            child: assignments.isEmpty || assignments[0] == null
                ? const Center(child: Text('Tidak ada tugas tersedia'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final task = assignments[index] as Map<String, dynamic>;
                      return _buildTugasCard(context, task);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasCard(BuildContext context, Map<String, dynamic> task) {
    final bool isDone = task['isDone'] ?? false;

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
            Navigator.pushNamed(context, AppRoutes.assignmentDetail, arguments: task);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        safeString(task['title'], 'Judul Tugas'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: isDone ? Colors.green : Colors.grey[300],
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  safeString(task['description'], 'Deskripsi belum tersedia'),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Deadline: ${safeString(task['deadline'], '-')}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
