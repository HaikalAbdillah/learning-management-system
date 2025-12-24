import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/constants/assets.dart';
import 'pentagon_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            PentagonShadow(
              size: 120,
              shadowColor: Colors.black,
              blurRadius: 10,
              offset: const Offset(0, 4),
              child: Image.asset(
                AppAssets.logo,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image fails to load
                  return Icon(Icons.school, size: 70, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ce-Loe', // Based on image text if legible, or generic
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              'Learning Management System',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
