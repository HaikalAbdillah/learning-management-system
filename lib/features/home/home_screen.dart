import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/class_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _getClassColor(String? type) {
    switch (type) {
      case 'ui_design':
        return Colors.red;
      case 'mobile_programming':
        return Colors.blue;
      case 'web_programming':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(context),

          const SizedBox(height: 20),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari pelajaran...",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Tasks Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Tugas Yang Akan Datang",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          const SizedBox(height: 10),

          // Upcoming Task Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildUpcomingTaskCard(context),
          ),

          const SizedBox(height: 24),

          // Announcements
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pengumuman Terakhir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/announcement-list');
                  },
                  child: const Text("Lihat Semua"),
                ),
              ],
            ),
          ),
          _buildAnnouncementBanner(context),

          const SizedBox(height: 24),

          // Class Progress Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Progres Kelas",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Class Progress List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ClassRepository.classes.length,
              itemBuilder: (context, index) {
                final cls = ClassRepository.classes[index];
                return GestureDetector(
                  onTap: () {
                    // Pass ID to detail screen
                    Navigator.pushNamed(
                      context,
                      '/class-detail',
                      arguments: cls['id'],
                    );
                  },
                  child: _buildProgressItem(
                    color: _getClassColor(cls['type']),
                    title: cls['title'],
                    code: "", // Default
                    progress: 0.0, // Default
                    iconText: cls['title'][0], // Simple icon logic
                    isImage: false, // For now simple
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Existing "Materi Terbaru"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Materi Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            itemCount: ClassRepository.classes
                .expand((c) => c['materi'] as List)
                .take(3)
                .length,
            itemBuilder: (context, index) {
              // Flatten all materials from all classes to show "Recent"
              // In a real app this would be sorted by date
              final allMaterials = ClassRepository.classes
                  .expand(
                    (c) => (c['materi'] as List).map(
                      (m) => {
                        ...m as Map<String, dynamic>,
                        'courseName': c['title'], // Add course name context
                      },
                    ),
                  )
                  .toList();

              final material = allMaterials[index];

              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/materi-detail',
                      arguments: material,
                    );
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    material['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "${material['courseName']}",
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: const BoxDecoration(
        color: AppTheme.secondaryColor, // Darker red based on image
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(
            0,
          ), // Removed curve to match image more closely or keep? Image doesn't show bottom clearly but likely straight or slight. adhering to previous style but with straight edges for "strip" look.
          // Actually image shows top bar is standard rect.
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo,',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'HAIKAL', // Real Name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: const [
                  Text(
                    "MAHASISWA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.person, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTaskCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/assignment-detail');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C), // Deep Red
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DESAIN ANTARMUKA & PENGALAMAN PENGGUNA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Tugas 01 - UID Android Mobile Game",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: const [
                  Text(
                    "Waktu Pengumpulan",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    "Jumat 26 Februari, 23:59 WIB",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/announcement-detail');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.blue[50], // Light blue bg
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for the illustration in the image
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.settings, color: Colors.orange[300], size: 40),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.warning, color: Colors.orange, size: 20),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Maintenance LMS",
                    style: TextStyle(
                      color: Color(0xFFC62828), // Dark red title
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Sabtu 12 Juni 2021",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem({
    required Color color,
    required String title,
    required String code,
    required double progress,
    String iconText = "",
    String iconSub = "",
    bool isImage = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Course Icon/Image Placeholder
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isImage
                ? const Icon(Icons.class_, color: Colors.white54, size: 30)
                : Stack(
                    children: [
                      Center(
                        child: Text(
                          iconText,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (iconSub.isNotEmpty)
                        Positioned(
                          bottom: 5,
                          right: 10,
                          child: Text(
                            iconSub,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "2021/2",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(progress * 100).toInt()}% Selesai",
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
