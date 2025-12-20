import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFDC143C), // Red color
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC143C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text('Notification ${index + 1}'),
              subtitle: const Text('This is a sample notification message'),
              trailing: const Text('10:30 AM'),
            ),
          );
        },
      ),
    );
  }
}
