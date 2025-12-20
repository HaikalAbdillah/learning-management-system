import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Lesson'),
        backgroundColor: const Color(0xFFDC143C), // Red color
      ),
      body: Column(
        children: [
          // Video player placeholder
          Container(
            height: 300,
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.play_arrow, size: 100, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // Video title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Getting Started with Flutter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Video description
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Learn the basics of Flutter development in this introductory video. We will cover the fundamental concepts and get you started with building your first Flutter application.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LinearProgressIndicator(
              value: 0.3,
              color: const Color(0xFFDC143C),
              backgroundColor: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text('30% watched'),
          ),
          const SizedBox(height: 30),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () {
                    // Previous video
                  },
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC143C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () {
                    // Next video
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
