import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFFDC143C)
                : (isLocked ? Colors.grey : Colors.blue),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted
                ? Icons.check
                : (isLocked ? Icons.lock : Icons.play_arrow),
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          isCompleted ? 'Completed' : (isLocked ? 'Locked' : 'Not started'),
          style: TextStyle(
            color: isCompleted
                ? Colors.green
                : (isLocked ? Colors.grey : Colors.blue),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: isLocked ? null : onTap,
      ),
    );
  }
}
