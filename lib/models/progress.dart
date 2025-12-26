enum MaterialType { pdf, ppt, video, zoom, quiz, assignment }

enum ProgressStatus { notStarted, inProgress, completed }

class MaterialProgress {
  final String materialId;
  final String materialTitle;
  final MaterialType type;
  final ProgressStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Duration timeSpent;
  final double progressPercentage; // 0.0 to 1.0
  final Map<String, dynamic>? metadata; // Additional data like quiz score, etc.

  const MaterialProgress({
    required this.materialId,
    required this.materialTitle,
    required this.type,
    this.status = ProgressStatus.notStarted,
    this.startedAt,
    this.completedAt,
    this.timeSpent = Duration.zero,
    this.progressPercentage = 0.0,
    this.metadata,
  });

  MaterialProgress copyWith({
    String? materialId,
    String? materialTitle,
    MaterialType? type,
    ProgressStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    Duration? timeSpent,
    double? progressPercentage,
    Map<String, dynamic>? metadata,
  }) {
    return MaterialProgress(
      materialId: materialId ?? this.materialId,
      materialTitle: materialTitle ?? this.materialTitle,
      type: type ?? this.type,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'materialTitle': materialTitle,
      'type': type.name,
      'status': status.name,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'timeSpent': timeSpent.inSeconds,
      'progressPercentage': progressPercentage,
      'metadata': metadata,
    };
  }

  factory MaterialProgress.fromJson(Map<String, dynamic> json) {
    return MaterialProgress(
      materialId: json['materialId'] ?? '',
      materialTitle: json['materialTitle'] ?? '',
      type: MaterialType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MaterialType.pdf,
      ),
      status: ProgressStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProgressStatus.notStarted,
      ),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      timeSpent: Duration(seconds: json['timeSpent'] ?? 0),
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
      metadata: json['metadata'],
    );
  }

  bool get isCompleted => status == ProgressStatus.completed;
  bool get isInProgress => status == ProgressStatus.inProgress;
  bool get isNotStarted => status == ProgressStatus.notStarted;
}

class CourseProgress {
  final String courseId;
  final String courseTitle;
  final List<MaterialProgress> materials;
  final DateTime? enrolledAt;
  final DateTime? lastAccessedAt;
  final Map<String, dynamic>? courseMetadata;

  const CourseProgress({
    required this.courseId,
    required this.courseTitle,
    this.materials = const [],
    this.enrolledAt,
    this.lastAccessedAt,
    this.courseMetadata,
  });

  double get overallProgress {
    if (materials.isEmpty) return 0.0;
    final totalProgress = materials.fold<double>(
      0.0,
      (sum, material) => sum + material.progressPercentage,
    );
    return totalProgress / materials.length;
  }

  int get completedMaterials => materials.where((m) => m.isCompleted).length;
  int get totalMaterials => materials.length;

  Duration get totalTimeSpent {
    return materials.fold<Duration>(
      Duration.zero,
      (sum, material) => sum + material.timeSpent,
    );
  }

  CourseProgress copyWith({
    String? courseId,
    String? courseTitle,
    List<MaterialProgress>? materials,
    DateTime? enrolledAt,
    DateTime? lastAccessedAt,
    Map<String, dynamic>? courseMetadata,
  }) {
    return CourseProgress(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      materials: materials ?? this.materials,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      courseMetadata: courseMetadata ?? this.courseMetadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'materials': materials.map((m) => m.toJson()).toList(),
      'enrolledAt': enrolledAt?.toIso8601String(),
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'courseMetadata': courseMetadata,
    };
  }

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      materials:
          (json['materials'] as List<dynamic>?)
              ?.map((m) => MaterialProgress.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'])
          : null,
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
      courseMetadata: json['courseMetadata'],
    );
  }
}

class LearningAnalytics {
  final String userId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Duration totalStudyTime;
  final int sessionsCount;
  final Map<String, int> materialTypeUsage; // pdf: 5, video: 3, etc.
  final Map<String, Duration>
  dailyStudyTime; // '2024-01-01': Duration(hours: 2)
  final List<Achievement> achievements;
  final Map<String, double> quizScores; // quizId: score
  final Map<String, bool> assignmentStatuses; // assignmentId: submitted

  const LearningAnalytics({
    required this.userId,
    required this.periodStart,
    required this.periodEnd,
    this.totalStudyTime = Duration.zero,
    this.sessionsCount = 0,
    this.materialTypeUsage = const {},
    this.dailyStudyTime = const {},
    this.achievements = const [],
    this.quizScores = const {},
    this.assignmentStatuses = const {},
  });

  double get averageSessionDuration {
    return sessionsCount > 0 ? totalStudyTime.inMinutes / sessionsCount : 0.0;
  }

  double get averageQuizScore {
    if (quizScores.isEmpty) return 0.0;
    final total = quizScores.values.fold<double>(
      0,
      (sum, score) => sum + score,
    );
    return total / quizScores.length;
  }

  int get completedAssignments =>
      assignmentStatuses.values.where((submitted) => submitted).length;
  int get totalAssignments => assignmentStatuses.length;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'totalStudyTime': totalStudyTime.inSeconds,
      'sessionsCount': sessionsCount,
      'materialTypeUsage': materialTypeUsage,
      'dailyStudyTime': dailyStudyTime.map(
        (key, value) => MapEntry(key, value.inSeconds),
      ),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'quizScores': quizScores,
      'assignmentStatuses': assignmentStatuses,
    };
  }

  factory LearningAnalytics.fromJson(Map<String, dynamic> json) {
    return LearningAnalytics(
      userId: json['userId'] ?? '',
      periodStart: DateTime.parse(
        json['periodStart'] ?? DateTime.now().toIso8601String(),
      ),
      periodEnd: DateTime.parse(
        json['periodEnd'] ?? DateTime.now().toIso8601String(),
      ),
      totalStudyTime: Duration(seconds: json['totalStudyTime'] ?? 0),
      sessionsCount: json['sessionsCount'] ?? 0,
      materialTypeUsage: Map<String, int>.from(json['materialTypeUsage'] ?? {}),
      dailyStudyTime:
          (json['dailyStudyTime'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, Duration(seconds: value as int)),
          ) ??
          {},
      achievements:
          (json['achievements'] as List<dynamic>?)
              ?.map((a) => Achievement.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      quizScores: Map<String, double>.from(json['quizScores'] ?? {}),
      assignmentStatuses: Map<String, bool>.from(
        json['assignmentStatuses'] ?? {},
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime? unlockedAt;
  final Map<String, dynamic>? metadata;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.unlockedAt,
    this.metadata,
  });

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      metadata: json['metadata'],
    );
  }
}

// Predefined achievements
class AchievementTemplates {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_login',
      title: 'First Steps',
      description: 'Login for the first time',
      iconName: 'login',
    ),
    Achievement(
      id: 'first_material',
      title: 'Knowledge Seeker',
      description: 'Complete your first learning material',
      iconName: 'book',
    ),
    Achievement(
      id: 'study_streak_7',
      title: 'Week Warrior',
      description: 'Study for 7 consecutive days',
      iconName: 'calendar',
    ),
    Achievement(
      id: 'quiz_perfect',
      title: 'Perfect Score',
      description: 'Get 100% on any quiz',
      iconName: 'trophy',
    ),
    Achievement(
      id: 'course_complete',
      title: 'Course Master',
      description: 'Complete an entire course',
      iconName: 'graduation_cap',
    ),
    Achievement(
      id: 'time_10h',
      title: 'Dedicated Learner',
      description: 'Spend 10 hours studying',
      iconName: 'clock',
    ),
  ];
}
