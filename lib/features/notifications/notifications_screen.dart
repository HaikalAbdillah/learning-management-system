import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFDC143C), // Red color
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Tugas Baru: UI Design Mobile',
        'subtitle':
            'Dosen baru saja menambahkan tugas baru untuk pertemuan ke-5.',
        'time': '10:30 AM',
        'category': 'tugas',
        'icon': Icons.assignment_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Maintenance Sistem',
        'subtitle': 'LMS akan dilakukan pemeliharaan rutin pada Sabtu malam.',
        'time': 'Yesterday',
        'category': 'system',
        'icon': Icons.settings_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Pengumuman: Kuliah Umum',
        'subtitle': 'Kuliah umum akan diadakan via Zoom pada Senin depan.',
        'time': '2 days ago',
        'category': 'announcement',
        'icon': Icons.campaign_outlined,
        'color': Colors.green,
      },
      {
        'title': 'Kuis Selesai: Dart Basics',
        'subtitle': 'Anda telah menyelesaikan kuis dengan skor 90/100.',
        'time': '3 days ago',
        'category': 'achievement',
        'icon': Icons.emoji_events_outlined,
        'color': Colors.purple,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (notif['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(notif['icon'], color: notif['color']),
            ),
            title: Text(
              notif['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  notif['subtitle'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  notif['time'],
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
