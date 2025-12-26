import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../core/utils/string_utils.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isSubmitted = false;
  String? _fileName;

  @override
  void initState() {
    super.initState();
  }

  void _handleUpload(Map<String, dynamic> taskData) {
    if (_isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas sudah dikumpulkan.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _fileName = "Jawaban_${taskData['title']?.toString().replaceAll(' ', '_')}.pdf";
    });

    // Simulate progress
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_uploadProgress < 1.0) {
        setState(() {
          _uploadProgress += 0.05;
        });
      } else {
        timer.cancel();
        setState(() {
          _isUploading = false;
          _isSubmitted = true;
        });
        
        // Mark as done in memory for this session (simulated)
        taskData['isDone'] = true;
        taskData['status'] = 'sudah_dikumpulkan';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Berhasil!'),
            content: const Text('Tugas Anda telah berhasil dikumpulkan.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> taskData = (args is Map<String, dynamic>)
        ? (args.containsKey('materi') ? args['materi'] : args)
        : {};

    final String title = safeString(taskData['title'], 'Tugas');
    final String description = safeString(
      taskData['description'],
      'Deskripsi tugas belum tersedia.',
    );
    final String deadline = safeString(taskData['deadline'], '-');
    final bool initialDone = taskData['isDone'] ?? false;
    final bool currentDone = _isSubmitted || initialDone;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Tugas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildInfoCard(
              context,
              'Deadline Pengumpulan',
              deadline,
              Icons.calendar_today_outlined,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Status Pengerjaan',
              currentDone ? 'Sudah Dikumpulkan' : 'Belum Dikumpulkan',
              currentDone
                  ? Icons.check_circle_outline
                  : Icons.pending_actions_outlined,
              currentDone ? Colors.green : Colors.grey,
            ),

            const SizedBox(height: 32),
            const Text(
              'Instruksi Tugas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 48),

            if (_isUploading) ...[
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mengunggah: $_fileName', style: const TextStyle(fontSize: 12)),
                      Text('${(_uploadProgress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.grey[200],
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 48),

            // Upload button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : () => _handleUpload(taskData),
                icon: Icon(
                  currentDone ? Icons.cloud_done : Icons.upload_file,
                  color: Colors.white,
                ),
                label: Text(
                  _isUploading 
                      ? 'Sedang Mengunggah...' 
                      : (currentDone ? 'Sudah Dikumpulkan' : 'Unggah Jawaban Sekarang'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentDone ? Colors.green : AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
