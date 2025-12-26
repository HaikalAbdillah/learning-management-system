import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress.dart';
import 'package:logging/logging.dart';

class ProgressService {
  static const String _progressKey = 'user_progress';
  static const String _analyticsKey = 'learning_analytics';
  static const String _achievementsKey = 'user_achievements';
  static final Logger _logger = Logger('ProgressService');

  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  SharedPreferences? _prefs;

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Course Progress Management
  Future<List<CourseProgress>> getAllCourseProgress() async {
    await _ensureInitialized();
    final progressJson = _prefs!.getString(_progressKey);
    if (progressJson == null) return [];

    try {
      final List<dynamic> progressList = json.decode(progressJson);
      return progressList
          .map((p) => CourseProgress.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.severe('Error loading course progress: $e');
      return [];
    }
  }

  Future<CourseProgress?> getCourseProgress(String courseId) async {
    final allProgress = await getAllCourseProgress();
    return allProgress.where((cp) => cp.courseId == courseId).firstOrNull;
  }

  Future<void> saveCourseProgress(CourseProgress courseProgress) async {
    await _ensureInitialized();
    final allProgress = await getAllCourseProgress();

    // Update or add the course progress
    final existingIndex = allProgress.indexWhere(
      (cp) => cp.courseId == courseProgress.courseId,
    );
    if (existingIndex >= 0) {
      allProgress[existingIndex] = courseProgress;
    } else {
      allProgress.add(courseProgress);
    }

    final progressJson = json.encode(
      allProgress.map((cp) => cp.toJson()).toList(),
    );
    await _prefs!.setString(_progressKey, progressJson);

    // Check for achievements
    await _checkAchievements(courseProgress);
  }

  Future<void> updateMaterialProgress(
    String courseId,
    MaterialProgress materialProgress,
  ) async {
    final courseProgress =
        await getCourseProgress(courseId) ??
        CourseProgress(
          courseId: courseId,
          courseTitle:
              'Unknown Course', // This should be updated with actual course title
        );

    final existingIndex = courseProgress.materials.indexWhere(
      (mp) => mp.materialId == materialProgress.materialId,
    );

    final updatedMaterials = List<MaterialProgress>.from(
      courseProgress.materials,
    );
    if (existingIndex >= 0) {
      updatedMaterials[existingIndex] = materialProgress;
    } else {
      updatedMaterials.add(materialProgress);
    }

    final updatedCourseProgress = courseProgress.copyWith(
      materials: updatedMaterials,
      lastAccessedAt: DateTime.now(),
    );

    await saveCourseProgress(updatedCourseProgress);
  }

  Future<void> markMaterialAsStarted(
    String courseId,
    String materialId,
    String materialTitle,
    MaterialType type,
  ) async {
    final existingProgress = await getMaterialProgress(courseId, materialId);

    if (existingProgress == null) {
      final newProgress = MaterialProgress(
        materialId: materialId,
        materialTitle: materialTitle,
        type: type,
        status: ProgressStatus.inProgress,
        startedAt: DateTime.now(),
      );
      await updateMaterialProgress(courseId, newProgress);
    } else if (existingProgress.isNotStarted) {
      final updatedProgress = existingProgress.copyWith(
        status: ProgressStatus.inProgress,
        startedAt: DateTime.now(),
      );
      await updateMaterialProgress(courseId, updatedProgress);
    }
  }

  Future<void> markMaterialAsCompleted(
    String courseId,
    String materialId, {
    Duration? timeSpent,
    Map<String, dynamic>? metadata,
  }) async {
    final existingProgress = await getMaterialProgress(courseId, materialId);
    if (existingProgress == null) return;

    final updatedProgress = existingProgress.copyWith(
      status: ProgressStatus.completed,
      completedAt: DateTime.now(),
      timeSpent: timeSpent ?? existingProgress.timeSpent,
      progressPercentage: 1.0,
      metadata: metadata ?? existingProgress.metadata,
    );

    await updateMaterialProgress(courseId, updatedProgress);
  }

  Future<void> updateMaterialTimeSpent(
    String courseId,
    String materialId,
    Duration additionalTime,
  ) async {
    final existingProgress = await getMaterialProgress(courseId, materialId);
    if (existingProgress == null) return;

    final newTimeSpent = existingProgress.timeSpent + additionalTime;
    final updatedProgress = existingProgress.copyWith(timeSpent: newTimeSpent);
    await updateMaterialProgress(courseId, updatedProgress);
  }

  Future<MaterialProgress?> getMaterialProgress(
    String courseId,
    String materialId,
  ) async {
    final courseProgress = await getCourseProgress(courseId);
    return courseProgress?.materials
        .where((mp) => mp.materialId == materialId)
        .firstOrNull;
  }

  // Learning Analytics
  Future<LearningAnalytics> getLearningAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _ensureInitialized();
    final analyticsJson = _prefs!.getString(_analyticsKey);

    if (analyticsJson != null) {
      try {
        final analytics = LearningAnalytics.fromJson(
          json.decode(analyticsJson),
        );
        // Check if we need to create new analytics for different period
        final now = DateTime.now();
        final periodStart = startDate ?? DateTime(now.year, now.month, 1);
        final periodEnd = endDate ?? DateTime(now.year, now.month + 1, 0);

        if (analytics.periodStart.isAtSameMomentAs(periodStart) &&
            analytics.periodEnd.isAtSameMomentAs(periodEnd)) {
          return analytics;
        }
      } catch (e) {
        _logger.severe('Error loading analytics: $e');
      }
    }

    // Create new analytics
    final now = DateTime.now();
    return LearningAnalytics(
      userId: 'current_user', // This should come from auth service
      periodStart: startDate ?? DateTime(now.year, now.month, 1),
      periodEnd: endDate ?? DateTime(now.year, now.month + 1, 0),
    );
  }

  Future<void> updateAnalytics(LearningAnalytics analytics) async {
    await _ensureInitialized();
    final analyticsJson = json.encode(analytics.toJson());
    await _prefs!.setString(_analyticsKey, analyticsJson);
  }

  Future<void> recordStudySession(
    Duration duration, {
    String? materialType,
  }) async {
    final analytics = await getLearningAnalytics();
    final today = DateTime.now().toIso8601String().split('T')[0];

    final updatedAnalytics = LearningAnalytics(
      userId: analytics.userId,
      periodStart: analytics.periodStart,
      periodEnd: analytics.periodEnd,
      totalStudyTime: analytics.totalStudyTime + duration,
      sessionsCount: analytics.sessionsCount + 1,
      materialTypeUsage: _updateMaterialTypeUsage(
        analytics.materialTypeUsage,
        materialType,
      ),
      dailyStudyTime: _updateDailyStudyTime(
        analytics.dailyStudyTime,
        today,
        duration,
      ),
      achievements: analytics.achievements,
      quizScores: analytics.quizScores,
      assignmentStatuses: analytics.assignmentStatuses,
    );

    await updateAnalytics(updatedAnalytics);
  }

  Future<void> recordQuizScore(String quizId, double score) async {
    final analytics = await getLearningAnalytics();
    final updatedScores = Map<String, double>.from(analytics.quizScores);
    updatedScores[quizId] = score;

    final updatedAnalytics = LearningAnalytics(
      userId: analytics.userId,
      periodStart: analytics.periodStart,
      periodEnd: analytics.periodEnd,
      totalStudyTime: analytics.totalStudyTime,
      sessionsCount: analytics.sessionsCount,
      materialTypeUsage: analytics.materialTypeUsage,
      dailyStudyTime: analytics.dailyStudyTime,
      achievements: analytics.achievements,
      quizScores: updatedScores,
      assignmentStatuses: analytics.assignmentStatuses,
    );

    await updateAnalytics(updatedAnalytics);
  }

  Future<void> recordAssignmentStatus(
    String assignmentId,
    bool submitted,
  ) async {
    final analytics = await getLearningAnalytics();
    final updatedStatuses = Map<String, bool>.from(
      analytics.assignmentStatuses,
    );
    updatedStatuses[assignmentId] = submitted;

    final updatedAnalytics = LearningAnalytics(
      userId: analytics.userId,
      periodStart: analytics.periodStart,
      periodEnd: analytics.periodEnd,
      totalStudyTime: analytics.totalStudyTime,
      sessionsCount: analytics.sessionsCount,
      materialTypeUsage: analytics.materialTypeUsage,
      dailyStudyTime: analytics.dailyStudyTime,
      achievements: analytics.achievements,
      quizScores: analytics.quizScores,
      assignmentStatuses: updatedStatuses,
    );

    await updateAnalytics(updatedAnalytics);
  }

  // Achievement Management
  Future<List<Achievement>> getUserAchievements() async {
    await _ensureInitialized();
    final achievementsJson = _prefs!.getString(_achievementsKey);
    if (achievementsJson == null) {
      // Initialize with default achievements
      final defaultAchievements = AchievementTemplates.all;
      final achievementsJson = json.encode(
        defaultAchievements.map((a) => a.toJson()).toList(),
      );
      await _prefs!.setString(_achievementsKey, achievementsJson);
      return defaultAchievements;
    }

    try {
      final List<dynamic> achievementsList = json.decode(achievementsJson);
      return achievementsList
          .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.severe('Error loading achievements: $e');
      return AchievementTemplates.all;
    }
  }

  Future<void> unlockAchievement(String achievementId) async {
    final achievements = await getUserAchievements();
    final existingIndex = achievements.indexWhere((a) => a.id == achievementId);

    if (existingIndex >= 0 && !achievements[existingIndex].isUnlocked) {
      achievements[existingIndex] = Achievement(
        id: achievements[existingIndex].id,
        title: achievements[existingIndex].title,
        description: achievements[existingIndex].description,
        iconName: achievements[existingIndex].iconName,
        unlockedAt: DateTime.now(),
        metadata: achievements[existingIndex].metadata,
      );

      final achievementsJson = json.encode(
        achievements.map((a) => a.toJson()).toList(),
      );
      await _prefs!.setString(_achievementsKey, achievementsJson);
    }
  }

  Future<void> _checkAchievements(CourseProgress courseProgress) async {
    // Check for first material completion
    if (courseProgress.completedMaterials >= 1) {
      await unlockAchievement('first_material');
    }

    // Check for course completion
    if (courseProgress.overallProgress >= 1.0) {
      await unlockAchievement('course_complete');
    }

    // Check for study time achievements
    final totalTime = courseProgress.totalTimeSpent;
    if (totalTime.inHours >= 10) {
      await unlockAchievement('time_10h');
    }
  }

  Map<String, int> _updateMaterialTypeUsage(
    Map<String, int> current,
    String? materialType,
  ) {
    if (materialType == null) return current;

    final updated = Map<String, int>.from(current);
    updated[materialType] = (updated[materialType] ?? 0) + 1;
    return updated;
  }

  Map<String, Duration> _updateDailyStudyTime(
    Map<String, Duration> current,
    String date,
    Duration duration,
  ) {
    final updated = Map<String, Duration>.from(current);
    updated[date] = (updated[date] ?? Duration.zero) + duration;
    return updated;
  }

  // Utility methods
  Future<void> clearAllProgress() async {
    await _ensureInitialized();
    await _prefs!.remove(_progressKey);
    await _prefs!.remove(_analyticsKey);
    await _prefs!.remove(_achievementsKey);
  }

  Future<Map<String, dynamic>> getProgressSummary() async {
    final allProgress = await getAllCourseProgress();
    final achievements = await getUserAchievements();

    final totalCourses = allProgress.length;
    final completedCourses = allProgress
        .where((cp) => cp.overallProgress >= 1.0)
        .length;
    final totalMaterials = allProgress.fold<int>(
      0,
      (sum, cp) => sum + cp.totalMaterials,
    );
    final completedMaterials = allProgress.fold<int>(
      0,
      (sum, cp) => sum + cp.completedMaterials,
    );

    // Calculate total study time from course progress
    final totalStudyTime = allProgress.fold<Duration>(
      Duration.zero,
      (sum, cp) => sum + cp.totalTimeSpent,
    );

    // Calculate average quiz score from completed quiz materials
    final quizScores = <double>[];
    for (final cp in allProgress) {
      for (final mp in cp.materials) {
        if (mp.type == MaterialType.quiz &&
            mp.isCompleted &&
            mp.metadata != null) {
          final score = mp.metadata!['score'];
          if (score is double) {
            quizScores.add(score);
          } else if (score is int) {
            quizScores.add(score.toDouble());
          }
        }
      }
    }
    final averageQuizScore = quizScores.isEmpty
        ? 0.0
        : quizScores.reduce((a, b) => a + b) / quizScores.length;

    return {
      'totalCourses': totalCourses,
      'completedCourses': completedCourses,
      'totalMaterials': totalMaterials,
      'completedMaterials': completedMaterials,
      'overallProgress': totalMaterials > 0
          ? completedMaterials / totalMaterials
          : 0.0,
      'totalStudyTime': totalStudyTime,
      'averageQuizScore': averageQuizScore,
      'unlockedAchievements': achievements.where((a) => a.isUnlocked).length,
      'totalAchievements': achievements.length,
    };
  }
}
