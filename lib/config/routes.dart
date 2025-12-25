import 'package:flutter/material.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/help_screen.dart';
import '../features/learning/class_detail_screen.dart';
import '../features/learning/materi_detail_screen.dart';
import '../features/learning/assignment_screen.dart';
import '../features/home/main_navigation.dart';
import '../features/courses/lesson_screen.dart';
import '../features/learning/quiz_screen.dart';
import '../features/learning/quiz_detail_screen.dart';
import '../features/learning/quiz_play_screen.dart';
import '../features/home/announcement_screen.dart';
import '../features/home/announcement_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/learning/document_viewer_screen.dart';
import '../features/learning/video_player_screen.dart';
import '../features/learning/browser_screen.dart';
import '../features/learning/slide_viewer_screen.dart';
import '../features/learning/tugas_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home'; // Main container with BottomNav
  static const String help = '/help';
  static const String classDetail = '/class-detail';
  static const String materiDetail = '/materi-detail';
  static const String lesson = '/lesson';
  static const String quiz = '/quiz';
  static const String quizDetail = '/quiz-detail';
  static const String quizPlay = '/quiz-play';
  static const String quizResult = '/quiz-result';
  static const String announcementDetail = '/announcement-detail';
  static const String announcementList = '/announcement-list';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String assignmentDetail = '/assignment-detail';
  static const String documentViewer = '/document-viewer';
  static const String videoPlayer = '/video-player';
  static const String browser = '/browser';
  static const String slideViewer = '/slide-viewer';
  static const String tugas = '/tugas';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case tugas:
        return MaterialPageRoute(
          builder: (_) => const TugasScreen(),
        );
      case slideViewer:
        return MaterialPageRoute(
          builder: (_) => const SlideViewerScreen(),
          settings: settings,
        );
      case browser:
        return MaterialPageRoute(
          builder: (_) => const BrowserScreen(),
          settings: settings,
        );
      case videoPlayer:
        return MaterialPageRoute(
          builder: (_) => const VideoPlayerScreen(),
          settings: settings,
        );
      case documentViewer:
        return MaterialPageRoute(
          builder: (_) => const DocumentViewerScreen(),
          settings: settings,
        );
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case classDetail:
        final classId = settings.arguments as int? ?? 1; // Default to 1 if null
        return MaterialPageRoute(
          builder: (_) => ClassDetailScreen(classId: classId),
        );
      case materiDetail:
        final materiData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MateriDetailScreen(materiData: materiData),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      case lesson:
        return MaterialPageRoute(builder: (_) => const LessonScreen());
      case quiz:
        return MaterialPageRoute(
          builder: (_) => const QuizScreen(),
        );
      case quizDetail:
        return MaterialPageRoute(builder: (_) => const QuizDetailScreen());
      case quizPlay:
        final quizData = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => QuizPlayScreen(quizData: quizData),
        );
      case quizResult:
        final args = settings.arguments as Map<String, dynamic>?;
        final score = args?['score'] ?? 0;
        return MaterialPageRoute(
          builder: (_) => QuizResultScreen(score: score),
        );
      case announcementDetail:
        return MaterialPageRoute(builder: (_) => const AnnouncementScreen());
      case announcementList:
        return MaterialPageRoute(
          builder: (_) => const AnnouncementListScreen(),
        );
      case assignmentDetail:
        return MaterialPageRoute(builder: (_) => const AssignmentScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
