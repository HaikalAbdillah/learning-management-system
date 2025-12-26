import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/utils/string_utils.dart';
import '../../models/materi.dart';
import '../../services/materi_progress_service.dart';
import 'materi_content/ui_design_content.dart';
import 'materi_content/mobile_programming_content.dart';
import 'materi_content/web_programming_content.dart';
import 'materi_content/cyber_security_content.dart';
import 'materi_content/default_content.dart';

class MateriDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? materiData;

  const MateriDetailScreen({super.key, this.materiData});

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Materi? _currentMateri;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMateriProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMateriProgress() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? materiData =
        widget.materiData ??
        ((args is Map<String, dynamic>)
            ? (args.containsKey('materi') ? args['materi'] : args)
            : null);

    if (materiData != null) {
      final materiId = materiData['id']?.toString() ?? '';
      final savedProgress = await MateriProgressService.getMateriProgress(
        materiId,
      );

      if (savedProgress != null) {
        setState(() {
          _currentMateri = savedProgress;
          _isLoading = false;
        });
      } else {
        // Create new materi with default progress
        final newMateri = Materi.fromJson(materiData);
        await MateriProgressService.saveMateriProgress(newMateri);
        setState(() {
          _currentMateri = newMateri;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? materiData =
        widget.materiData ??
        ((args is Map<String, dynamic>)
            ? (args.containsKey('materi') ? args['materi'] : args)
            : null);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          safeString(materiData?['title'], 'Detail Materi'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Lampiran Materi"),
            Tab(text: "Tugas dan Kuis"),
            Tab(text: "Absensi"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLampiranTab(), _buildTugasTab(), _buildAbsensiTab()],
      ),
    );
  }

  Widget _buildLampiranTab() {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? materiData =
        widget.materiData ??
        ((args is Map<String, dynamic>)
            ? (args.containsKey('materi') ? args['materi'] : args)
            : null);

    // Convert to Materi model
    final materi = materiData != null ? Materi.fromJson(materiData) : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Content based on type
          _buildDynamicContent(materiData),
          const SizedBox(height: 20),

          // Lampiran Materi
          if (materi != null && materi.lampiran.isNotEmpty) ...[
            Text(
              'Lampiran Materi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            // List Lampiran
            ...materi.lampiran.map((lampiran) {
              return _buildLampiranItem(lampiran);
            }),
          ] else ...[
            _buildEmptyState(
              'Belum ada materi pada pertemuan ini',
              'Lampiran materi akan muncul di sini ketika sudah tersedia',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTugasTab() {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? materiData =
        widget.materiData ??
        ((args is Map<String, dynamic>)
            ? (args.containsKey('materi') ? args['materi'] : args)
            : null);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuCard(
            title: 'Tugas',
            subtitle: 'Lihat daftar tugas untuk materi ini',
            icon: Icons.assignment_outlined,
            color: Colors.blue,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.tugas,
                arguments: {'materi': materiData ?? {}},
              );
            },
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Kuis',
            subtitle: 'Kerjakan kuis untuk menguji pemahaman Anda',
            icon: Icons.quiz_outlined,
            color: Colors.purple,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.quiz,
                arguments: {'materi': materiData ?? {}},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiTab() {
    if (_isLoading || _currentMateri == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progres Materi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                _buildProgressItem(
                  'PDF/PPT',
                  _currentMateri!.materiProgress['pdf'] ?? false,
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  'Video Tutorial',
                  _currentMateri!.materiProgress['video'] ?? false,
                ),
                const SizedBox(height: 12),
                _buildProgressItem(
                  'Zoom Meeting',
                  _currentMateri!.materiProgress['zoom'] ?? false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Absensi Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _currentMateri!.isAbsenDone
                      ? 'Absensi Berhasil'
                      : _currentMateri!.isAbsenAvailable
                      ? 'Absensi Siap Dilakukan'
                      : 'Selesaikan Materi Terlebih Dahulu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _currentMateri!.isAbsenDone
                        ? Colors.green[700]
                        : _currentMateri!.isAbsenAvailable
                        ? AppTheme.primaryColor
                        : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _currentMateri!.isAbsenAvailable &&
                            !_currentMateri!.isAbsenDone
                        ? _performAbsensi
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _currentMateri!.isAbsenAvailable &&
                              !_currentMateri!.isAbsenDone
                          ? AppTheme.primaryColor
                          : Colors.grey[300],
                      foregroundColor:
                          _currentMateri!.isAbsenAvailable &&
                              !_currentMateri!.isAbsenDone
                          ? Colors.white
                          : Colors.grey[500],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentMateri!.isAbsenDone
                          ? 'Hadir ✓'
                          : 'Absen Sekarang',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.green[100] : Colors.grey[200],
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.schedule,
            size: 16,
            color: isCompleted ? Colors.green[700] : Colors.grey[500],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? Colors.black87 : Colors.grey[600],
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _performAbsensi() async {
    if (_currentMateri != null &&
        _currentMateri!.isAbsenAvailable &&
        !_currentMateri!.isAbsenDone) {
      await MateriProgressService.markAbsensiDone(_currentMateri!.id);
      setState(() {
        _currentMateri = _currentMateri!.copyWith(isAbsenDone: true);
      });
    }
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        safeString(title, 'Tugas/Kuis'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        safeString(subtitle, '-'),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLampiranItem(LampiranMateri lampiran) {
    final isCompleted = _isLampiranCompleted(lampiran.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: lampiran.isAvailable ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (lampiran.isAvailable)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
        border: lampiran.isAvailable
            ? null
            : Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: lampiran.isAvailable
              ? () => _handleLampiranTap(lampiran)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lampiran.isAvailable
                        ? _getLampiranColor(
                            lampiran.type,
                          ).withValues(alpha: 0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    lampiran.getIcon(),
                    color: lampiran.isAvailable
                        ? _getLampiranColor(lampiran.type)
                        : Colors.grey[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lampiran.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: lampiran.isAvailable
                                    ? Colors.black87
                                    : Colors.grey[500],
                              ),
                            ),
                          ),
                          if (lampiran.isAvailable) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                              ),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.schedule,
                                size: 12,
                                color: isCompleted
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lampiran.isAvailable
                            ? _getLampiranDescription(lampiran)
                            : 'Materi belum tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: lampiran.isAvailable
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lampiran.isAvailable
                        ? _getLampiranColor(
                            lampiran.type,
                          ).withValues(alpha: 0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lampiran.getTypeLabel(),
                    style: TextStyle(
                      fontSize: 10,
                      color: lampiran.isAvailable
                          ? _getLampiranColor(lampiran.type)
                          : Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isLampiranCompleted(String type) {
    if (_currentMateri == null) return false;

    switch (type) {
      case 'pdf':
      case 'ppt':
      case 'slide':
        return _currentMateri!.materiProgress['pdf'] ?? false;
      case 'video':
        return _currentMateri!.materiProgress['video'] ?? false;
      case 'zoom':
        return _currentMateri!.materiProgress['zoom'] ?? false;
      default:
        return false;
    }
  }

  Widget _buildDynamicContent(Map<String, dynamic>? materiData) {
    if (materiData == null) return const SizedBox();

    final type = materiData['type'];

    Widget content;
    switch (type) {
      case 'ui_ux':
        content = const UIDesignContent();
        break;
      case 'mobile_programming':
        content = const MobileProgrammingContent();
        break;
      case 'web_programming':
        content = const WebProgrammingContent();
        break;
      case 'cyber_security':
        content = CyberSecurityContent(materiData: materiData);
        break;
      default:
        content = DefaultMateriContent(materiData: materiData);
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );
  }

  Future<void> _handleLampiranTap(LampiranMateri lampiran) async {
    // Track progress based on lampiran type
    String? progressType;
    switch (lampiran.type) {
      case 'pdf':
      case 'ppt':
      case 'slide':
        progressType = 'pdf';
        break;
      case 'video':
        progressType = 'video';
        break;
      case 'zoom':
        progressType = 'zoom';
        break;
    }

    // Update progress if not already completed
    if (progressType != null &&
        _currentMateri != null &&
        !(_currentMateri!.materiProgress[progressType] ?? false)) {
      await MateriProgressService.updateMateriProgress(
        _currentMateri!.id,
        progressType,
        true,
      );

      // Reload progress
      await _loadMateriProgress();
    }

    switch (lampiran.type) {
      case 'pdf':
      case 'ppt':
        // Navigate to document viewer
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.documentViewer,
            arguments: {
              'title': lampiran.title,
              'path': lampiran.source,
              'type': lampiran.type,
            },
          );
        }
        break;
      case 'slide':
        // Navigate to slide viewer
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.slideViewer,
            arguments: {
              'title': lampiran.title,
              'path': lampiran.source,
              'slides': lampiran.source == 'assets/materi/cyber_security'
                  ? [
                      'pertemuan pertama cyber_page-0001.jpg',
                      'pertemuan pertama cyber_page-0002.jpg',
                      'pertemuan pertama cyber_page-0003.jpg',
                      'pertemuan pertama cyber_page-0004.jpg',
                      'pertemuan pertama cyber_page-0005.jpg',
                      'pertemuan pertama cyber_page-0006.jpg',
                      'pertemuan pertama cyber_page-0007.jpg',
                    ]
                  : [],
            },
          );
        }
        break;
      case 'video':
        // Navigate to video player
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.videoPlayer,
            arguments: {
              'title': lampiran.title,
              'url': lampiran.source,
              'materiId': _currentMateri?.id,
            },
          );
        }
        break;
      case 'zoom':
        // Open in external browser
        if (lampiran.source.isNotEmpty) {
          launchUrl(
            Uri.parse(lampiran.source),
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Removed: ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Link Zoom tidak tersedia')),
          // );
        }
        break;
      default:
      // Removed: ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Membuka ${lampiran.title}')),
      // );
    }
  }

  Color _getLampiranColor(String type) {
    switch (type) {
      case 'pdf':
      case 'ppt':
        return Colors.red;
      case 'video':
        return Colors.blue;
      case 'zoom':
        return Colors.purple;
      default:
        return AppTheme.primaryColor;
    }
  }

  String _getLampiranDescription(LampiranMateri lampiran) {
    switch (lampiran.type) {
      case 'pdf':
      case 'ppt':
      case 'slide':
        return 'Buka dokumen ${lampiran.type.toUpperCase()}';
      case 'video':
        return 'Putar video tutorial';
      case 'zoom':
        return 'Bergabung ke sesi Zoom';
      default:
        return 'Buka lampiran';
    }
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            safeString(title, 'Pemberitahuan'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            safeString(subtitle, '-'),
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
