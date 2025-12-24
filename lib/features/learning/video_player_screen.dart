import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/app_theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  late Map lampiran;
  String? videoId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map) {
      lampiran = args;
      videoId = YoutubePlayer.convertUrlToId(lampiran['url'] ?? '');

      _controller = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(listener);
    }
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next screen.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.primaryColor,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        if (ModalRoute.of(context)?.settings.arguments == null ||
            videoId == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.primaryColor,
              title: const Text('Video Tutorial'),
            ),
            body: const Center(
              child: Text('Tidak ada video tutorial'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              lampiran['title'] ?? 'Video Player',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lampiran['title'] ?? 'Judul Video',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Deskripsi Video: Tutorial ini akan membantu Anda memahami materi dengan lebih baik melalui panduan visual.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        )),
                    const SizedBox(height: 20),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Tentang Platform'),
                      subtitle: Text('YouTube'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
