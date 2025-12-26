import 'dart:io';
import 'package:logging/logging.dart';
import 'package:elearningms/services/class_repository.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    stdout.writeln('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('TestRepositoryData');

  logger.info('Classes count: ${ClassRepository.classes.length}');
  for (var cls in ClassRepository.classes) {
    logger.info('Class: ${cls['title']} (ID: ${cls['id']})');
    final materi = cls['materi'] as List;
    logger.info('  Materi count: ${materi.length}');
    for (var m in materi) {
      final tugas = m['tugas'] as List;
      final kuis = m['kuis'] as List;
      logger.info(
        '    Meeting: ${m['title']} - Tugas: ${tugas.length}, Kuis: ${kuis.length}',
      );
    }
  }
}
