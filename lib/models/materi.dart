import 'package:flutter/material.dart';

class Materi {
  final String id;
  final String judul;
  final List<LampiranMateri> lampiran;
  final Map<String, bool> materiProgress;
  final bool isMateriCompleted;
  final bool isAbsenAvailable;
  final bool isAbsenDone;

  Materi({
    required this.id,
    required this.judul,
    required this.lampiran,
    this.materiProgress = const {'pdf': false, 'video': false, 'zoom': false},
    this.isMateriCompleted = false,
    this.isAbsenAvailable = false,
    this.isAbsenDone = false,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id']?.toString() ?? '',
      judul: json['title'] ?? '',
      lampiran: (json['materi'] as List<dynamic>?)
          ?.map((e) => LampiranMateri.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      materiProgress: Map<String, bool>.from(json['materiProgress'] ?? {'pdf': false, 'video': false, 'zoom': false}),
      isMateriCompleted: json['isMateriCompleted'] ?? false,
      isAbsenAvailable: json['isAbsenAvailable'] ?? false,
      isAbsenDone: json['isAbsenDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': judul,
      'lampiran': lampiran.map((e) => e.toJson()).toList(),
      'materiProgress': materiProgress,
      'isMateriCompleted': isMateriCompleted,
      'isAbsenAvailable': isAbsenAvailable,
      'isAbsenDone': isAbsenDone,
    };
  }

  // Helper method to check if materi is completed
  bool get checkMateriCompleted {
    return (materiProgress['pdf'] == true) && (materiProgress['video'] == true);
  }

  // Helper method to check if absensi is available
  bool get checkAbsenAvailable {
    return checkMateriCompleted;
  }

  // Create a copy with updated progress
  Materi copyWith({
    String? id,
    String? judul,
    List<LampiranMateri>? lampiran,
    Map<String, bool>? materiProgress,
    bool? isMateriCompleted,
    bool? isAbsenAvailable,
    bool? isAbsenDone,
  }) {
    return Materi(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      lampiran: lampiran ?? this.lampiran,
      materiProgress: materiProgress ?? this.materiProgress,
      isMateriCompleted: isMateriCompleted ?? this.isMateriCompleted,
      isAbsenAvailable: isAbsenAvailable ?? this.isAbsenAvailable,
      isAbsenDone: isAbsenDone ?? this.isAbsenDone,
    );
  }
}

class LampiranMateri {
  final String type; // pdf | ppt | video | zoom
  final String title;
  final String source; // asset path / youtube url / zoom link
  final bool isAvailable;

  LampiranMateri({
    required this.type,
    required this.title,
    required this.source,
    required this.isAvailable,
  });

  factory LampiranMateri.fromJson(Map<String, dynamic> json) {
    return LampiranMateri(
      type: json['type']?.toString().toLowerCase() ?? 'unknown',
      title: json['title'] ?? '',
      source: json['source'] ?? json['path'] ?? json['url'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'source': source,
      'isAvailable': isAvailable,
    };
  }

  IconData getIcon() {
    switch (type) {
      case 'pdf':
      case 'ppt':
      case 'slide':
        return Icons.description;
      case 'video':
        return Icons.play_circle_fill;
      case 'zoom':
        return Icons.video_call;
      default:
        return Icons.link;
    }
  }

  String getTypeLabel() {
    switch (type) {
      case 'pdf':
        return 'PDF';
      case 'ppt':
        return 'PPT';
      case 'slide':
        return 'SLIDE';
      case 'video':
        return 'VIDEO';
      case 'zoom':
        return 'ZOOM';
      default:
        return 'FILE';
    }
  }
}