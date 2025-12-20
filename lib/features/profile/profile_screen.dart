import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
               // Edit Profile
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  color: AppTheme.primaryColor,
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            
            const Text(
              "Haikal Abdillah",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Mahasiswa",
              style: TextStyle(color: Colors.grey),
            ),
            
            const SizedBox(height: 30),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                   _buildProfileMenu(Icons.person_outline, "Data Diri"),
                   _buildProfileMenu(Icons.school_outlined, "Riwayat Akademik"),
                   _buildProfileMenu(Icons.lock_outline, "Ubah Password"),
                   _buildProfileMenu(Icons.help_outline, "Bantuan"),
                   const SizedBox(height: 20),
                   SizedBox(
                     width: double.infinity,
                     child: OutlinedButton(
                       onPressed: () {},
                       style: OutlinedButton.styleFrom(
                         side: const BorderSide(color: Colors.red),
                         padding: const EdgeInsets.symmetric(vertical: 16),
                       ),
                       child: const Text("Keluar", style: TextStyle(color: Colors.red)),
                     ),
                   )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
