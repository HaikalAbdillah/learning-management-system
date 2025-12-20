import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../shared/widgets/course_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Halo, Haikal!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mahasiswa',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Search Field
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 24),
             child: TextField(
               decoration: InputDecoration(
                 hintText: "Cari pelajaran...",
                 prefixIcon: Icon(Icons.search),
                 fillColor: Colors.grey[200],
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                 enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                 focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: AppTheme.primaryColor)),
               )
             )
          ),

          const SizedBox(height: 25),

          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kelas Saya', // "Learning Progress" or similar
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {}, // Navigate to My Classes tab
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          // Horizontal List of Courses
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                CourseCard(
                  title: 'UI/UX Design',
                  instructor: 'Dedi Triguna, S.T., M.Kom',
                  progress: 0.7,
                  color: Colors.orange[100]!,
                  imageUrl: '', // Placeholder
                ),
                CourseCard(
                  title: 'Mobile Programming',
                  instructor: 'Haikal Abdillah',
                  progress: 0.3,
                  color: Colors.blue[100]!,
                  imageUrl: '', // Placeholder
                ),
                CourseCard(
                  title: 'Web Development',
                  instructor: 'Google',
                  progress: 0.1,
                  color: Colors.green[100]!,
                  imageUrl: '', // Placeholder
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // "Materi Terbaru" or "Recommendations"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: const Text(
              'Materi Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.play_circle_fill, color: AppTheme.primaryColor),
                  ),
                  title: Text("Pengenalan Flutter", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Mobile Programming • 15 Mins"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            }
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
