import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/materi.dart';

class MateriProgressService {
  static const String _progressKey = 'materi_progress';

  // Get progress for a specific materi
  static Future<Materi?> getMateriProgress(String materiId) async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = prefs.getString(_progressKey);

    if (progressData != null) {
      final Map<String, dynamic> allProgress = json.decode(progressData);
      final materiData = allProgress[materiId];

      if (materiData != null) {
        return Materi.fromJson(materiData);
      }
    }

    return null;
  }

  // Save progress for a specific materi
  static Future<void> saveMateriProgress(Materi materi) async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = prefs.getString(_progressKey);
    Map<String, dynamic> allProgress = {};

    if (progressData != null) {
      allProgress = json.decode(progressData);
    }

    allProgress[materi.id] = materi.toJson();
    await prefs.setString(_progressKey, json.encode(allProgress));
  }

  // Update progress for a specific materi type
  static Future<void> updateMateriProgress(String materiId, String type, bool completed) async {
    final materi = await getMateriProgress(materiId);
    if (materi != null) {
      final updatedProgress = Map<String, bool>.from(materi.materiProgress);
      updatedProgress[type] = completed;

      final updatedMateri = materi.copyWith(
        materiProgress: updatedProgress,
        isMateriCompleted: materi.checkMateriCompleted,
        isAbsenAvailable: materi.checkAbsenAvailable,
      );

      await saveMateriProgress(updatedMateri);
    }
  }

  // Mark absensi as done
  static Future<void> markAbsensiDone(String materiId) async {
    final materi = await getMateriProgress(materiId);
    if (materi != null && materi.isAbsenAvailable && !materi.isAbsenDone) {
      final updatedMateri = materi.copyWith(isAbsenDone: true);
      await saveMateriProgress(updatedMateri);
    }
  }

  // Get all progress data
  static Future<Map<String, Materi>> getAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressData = prefs.getString(_progressKey);
    Map<String, Materi> allProgress = {};

    if (progressData != null) {
      final Map<String, dynamic> decoded = json.decode(progressData);
      decoded.forEach((key, value) {
        allProgress[key] = Materi.fromJson(value);
      });
    }

    return allProgress;
  }

  // Clear all progress (for testing)
  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}