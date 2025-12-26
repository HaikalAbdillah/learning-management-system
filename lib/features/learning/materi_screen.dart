import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/utils/string_utils.dart';
import '../../models/progress.dart' as progress_models;
import '../../services/progress_service.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? meetingData;
  bool isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Map<String, progress_models.MaterialProgress> materialProgressMap = {};
  String? courseId;
  String? meetingId;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      // Extract course and meeting IDs for progress tracking
      courseId = args['courseId'] ?? 'unknown_course';
      meetingId = args['id']?.toString() ?? 'unknown_meeting';

      // Load progress data
      await _loadProgressData();

      setState(() {
        meetingData = args;
        isLoading = false;
      });
      _fadeController.forward();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadProgressData() async {
    if (courseId == null) return;

    try {
      final courseProgress = await ProgressService().getCourseProgress(
        courseId!,
      );
      if (courseProgress != null) {
        final progressMap = <String, progress_models.MaterialProgress>{};
        for (final material in courseProgress.materials) {
          progressMap[material.materialId] = material;
        }
        setState(() {
          materialProgressMap = progressMap;
        });
      }
    } catch (e) {
      Logger('MateriScreen').severe('Error loading progress data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingScreen();
    }

    if (meetingData == null) {
      return _buildErrorScreen();
    }

    final materiList = meetingData?['materi'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          safeString(meetingData?['title'], 'Materi Pertemuan'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 600;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isWideScreen ? 32 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildResponsiveHeader(isWideScreen),
                  SizedBox(height: isWideScreen ? 24 : 20),

                  // Materi List
                  if (materiList.isNotEmpty) ...[
                    _buildMateriSection(materiList, isWideScreen),
                  ] else ...[
                    _buildEmptyState(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Memuat Materi...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat materi pertemuan...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Error',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data pertemuan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan coba lagi',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveHeader(bool isWideScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWideScreen ? 24 : 20),
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
            safeString(meetingData?['title'], 'Pertemuan'),
            style: TextStyle(
              fontSize: isWideScreen ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWideScreen ? 12 : 8),
          Text(
            'Pilih materi yang ingin Anda akses',
            style: TextStyle(
              fontSize: isWideScreen ? 16 : 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriSection(List<dynamic> materiList, bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Materi Tersedia',
          style: TextStyle(
            fontSize: isWideScreen ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: isWideScreen ? 20 : 16),
        if (isWideScreen)
          _buildWideScreenMateriGrid(materiList)
        else
          ...materiList.map((materi) => _buildAnimatedMateriCard(materi)),
      ],
    );
  }

  Widget _buildWideScreenMateriGrid(List<dynamic> materiList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: materiList.length,
      itemBuilder: (context, index) {
        return _buildAnimatedMateriCard(materiList[index]);
      },
    );
  }

  Widget _buildAnimatedMateriCard(Map<String, dynamic> materi) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      child: _buildMateriCard(materi),
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> materi) {
    final type = safeString(materi['type'], "unknown");
    final title = safeString(materi['title'], "Materi");
    final isAvailable = materi['isAvailable'] as bool? ?? false;
    final materialId =
        '${meetingId}_${materi['type']}_${title.replaceAll(' ', '_').toLowerCase()}';

    // Get progress data
    final progress = materialProgressMap[materialId];
    final isCompleted = progress?.isCompleted ?? false;
    final isInProgress = progress?.isInProgress ?? false;

    final String materiLabel =
        '$title, ${_getMateriDescription(type)}, ${isAvailable ? 'Tersedia' : 'Tidak tersedia'}, ${isCompleted
            ? 'Selesai'
            : isInProgress
            ? 'Sedang dipelajari'
            : 'Belum dimulai'}';

    final String materiHint = isAvailable
        ? "Ketuk untuk membuka materi"
        : "Materi belum tersedia";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: isAvailable
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        border: isAvailable ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isAvailable
              ? () => _handleMateriTap(materi, materialId)
              : null,
          focusColor: _getMateriColor(type).withValues(alpha: 0.1),
          hoverColor: _getMateriColor(type).withValues(alpha: 0.05),
          child: Semantics(
            label: materiLabel,
            hint: materiHint,
            enabled: isAvailable,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? _getMateriColor(type).withValues(alpha: 0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getMateriIcon(type),
                          color: isAvailable
                              ? _getMateriColor(type)
                              : Colors.grey[400],
                          size: 28,
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
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isAvailable
                                          ? Colors.black87
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isAvailable
                                  ? _getMateriDescription(type)
                                  : "Materi belum tersedia",
                              style: TextStyle(
                                fontSize: 12,
                                color: isAvailable
                                    ? Colors.grey[600]
                                    : Colors.grey[400],
                              ),
                            ),
                            if (progress != null &&
                                progress.timeSpent.inMinutes > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Waktu belajar: ${_formatDuration(progress.timeSpent)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAvailable
                              ? _getMateriColor(type).withValues(alpha: 0.1)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getMateriTypeLabel(type),
                          style: TextStyle(
                            fontSize: 10,
                            color: isAvailable
                                ? _getMateriColor(type)
                                : Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isInProgress) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress?.progressPercentage ?? 0.0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getMateriColor(type),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Materi pada pertemuan ini belum tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Materi akan muncul di sini ketika sudah tersedia',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleMateriTap(Map<String, dynamic> materi, String materialId) async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    final type = safeString(materi['type'], 'unknown');
    final title = safeString(materi['title'], 'Materi');
    final source = safeString(materi['source'], '');

    // Mark material as started
    if (courseId != null) {
      await ProgressService().markMaterialAsStarted(
        courseId!,
        materialId,
        title,
        _getMaterialTypeFromString(type),
      );
    }

    // Check if context is still valid
    if (!mounted) return;

    final startTime = DateTime.now();

    try {
      switch (type) {
        case 'pdf':
        case 'ppt':
          // Navigate to document viewer
          if (mounted) {
            await Navigator.pushNamed(
              context,
              AppRoutes.documentViewer,
              arguments: {'title': title, 'path': source, 'type': type},
            );
          }
          break;
        case 'video':
          // Navigate to video player
          if (mounted) {
            await Navigator.pushNamed(
              context,
              AppRoutes.videoPlayer,
              arguments: {'title': title, 'url': source},
            );
          }
          break;
        case 'zoom':
          // Open in external browser
          if (source.isNotEmpty) {
            final success = await launchUrl(
              Uri.parse(source),
              mode: LaunchMode.externalApplication,
            );
            if (!success && mounted) {
              // Removed: ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Gagal membuka link Zoom')),
              // );
            }
          } else if (mounted) {
            // Removed: ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Link Zoom tidak tersedia')),
            // );
          }
          break;
        default:
          if (mounted) {
            // Removed: ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Format file $type tidak didukung')),
            // );
          }
      }

      // Track time spent and mark as completed
      final endTime = DateTime.now();
      final timeSpent = endTime.difference(startTime);

      if (courseId != null && timeSpent.inSeconds > 10) {
        // Only track if spent more than 10 seconds
        await ProgressService().updateMaterialTimeSpent(
          courseId!,
          materialId,
          timeSpent,
        );

        // Mark as completed for certain material types or if spent significant time
        if (type == 'zoom' || timeSpent.inMinutes >= 5) {
          await ProgressService().markMaterialAsCompleted(
            courseId!,
            materialId,
          );
        }

        // Refresh progress data
        await _loadProgressData();
      }
    } catch (e) {
      if (mounted) {
        // Removed: ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  progress_models.MaterialType _getMaterialTypeFromString(String type) {
    switch (type) {
      case 'pdf':
        return progress_models.MaterialType.pdf;
      case 'ppt':
        return progress_models.MaterialType.ppt;
      case 'video':
        return progress_models.MaterialType.video;
      case 'zoom':
        return progress_models.MaterialType.zoom;
      default:
        return progress_models.MaterialType.pdf;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}j ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}d';
    } else {
      return '${duration.inSeconds}d';
    }
  }

  IconData _getMateriIcon(String type) {
    switch (type) {
      case 'pdf':
      case 'ppt':
        return Icons.description;
      case 'video':
        return Icons.play_circle_fill;
      case 'zoom':
        return Icons.video_call;
      default:
        return Icons.link;
    }
  }

  Color _getMateriColor(String type) {
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

  String _getMateriDescription(String type) {
    switch (type) {
      case 'pdf':
      case 'ppt':
        return 'Buka dokumen';
      case 'video':
        return 'Putar video tutorial';
      case 'zoom':
        return 'Bergabung ke sesi Zoom';
      default:
        return 'Buka materi';
    }
  }

  String _getMateriTypeLabel(String type) {
    switch (type) {
      case 'pdf':
        return "PDF";
      case 'ppt':
        return "PPT";
      case 'video':
        return "VIDEO";
      case 'zoom':
        return "ZOOM";
      default:
        return "FILE";
    }
  }
}
