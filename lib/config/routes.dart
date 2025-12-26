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
import '../features/learning/quiz_result_screen.dart';
import '../features/home/announcement_screen.dart';
import '../features/home/announcement_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/learning/document_viewer_screen.dart';
import '../features/learning/video_player_screen.dart';
import '../features/learning/browser_screen.dart';
import '../features/learning/slide_viewer_screen.dart';
import '../features/learning/tugas_screen.dart';
import '../features/learning/upload_assignment_screen.dart';
import '../features/learning/materi_screen.dart';
import '../features/learning/progress_dashboard_screen.dart';
import '../features/home/material_search_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
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
  static const String uploadAssignment = '/upload-assignment';
  static const String materi = '/materi';
  static const String progressDashboard = '/progress-dashboard';
  static const String materialSearch = '/material-search';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const MainNavigation(),
    help: (context) => const HelpScreen(),
    classDetail: (context) => const ClassDetailScreen(),
    materiDetail: (context) => const MateriDetailScreen(),
    lesson: (context) => const LessonScreen(),
    quiz: (context) => const QuizScreen(),
    quizDetail: (context) => const QuizDetailScreen(),
    quizPlay: (context) => const QuizPlayScreen(),
    quizResult: (context) => const QuizResultScreen(),
    announcementDetail: (context) => const AnnouncementScreen(),
    announcementList: (context) => const AnnouncementListScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    assignmentDetail: (context) => const AssignmentScreen(),
    documentViewer: (context) => const DocumentViewerScreen(),
    videoPlayer: (context) => const VideoPlayerScreen(),
    browser: (context) => const BrowserScreen(),
    slideViewer: (context) => const SlideViewerScreen(),
    tugas: (context) => const TugasScreen(),
    uploadAssignment: (context) => const UploadAssignmentScreen(),
    materi: (context) => const MateriScreen(),
    progressDashboard: (context) => const ProgressDashboardScreen(),
    materialSearch: (context) => const MaterialSearchScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('No route defined for ${settings.name}')),
      ),
    );
  }
}

