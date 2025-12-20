import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String progress;
  final double progressValue;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.progress,
    required this.progressValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.book, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progressValue,
                  color: const Color(0xFFDC143C),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 5),
                Text(progress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
