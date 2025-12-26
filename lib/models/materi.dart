import 'package:flutter/material.dart';

class Materi {
  final String id;
  final String judul;
  final List<LampiranMateri> lampiran;

  Materi({
    required this.id,
    required this.judul,
    required this.lampiran,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id']?.toString() ?? '',
      judul: json['title'] ?? '',
      lampiran: (json['lampiran'] as List<dynamic>?)
          ?.map((e) => LampiranMateri.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': judul,
      'lampiran': lampiran.map((e) => e.toJson()).toList(),
    };
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