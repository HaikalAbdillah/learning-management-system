import 'package:flutter/material.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: const Color(0xFFDC143C), // Red color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course header
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Icon(Icons.book, size: 80, color: Color(0xFFDC143C)),
              ),
            ),
            const SizedBox(height: 20),

            // Course title and progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Introduction to Flutter Development',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Instructor: Jane Smith',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Progress bar
                  const Text(
                    'Progress: 60%',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.6,
                    color: const Color(0xFFDC143C),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 30),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This course covers the fundamentals of Flutter development, including widgets, state management, navigation, and more. You will learn how to build beautiful and responsive mobile applications for both Android and iOS platforms.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  // Modules
                  const Text(
                    'Modules',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Module list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 5.0,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index < 3
                            ? const Color(0xFFDC143C)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        index < 3 ? Icons.check : Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Module ${index + 1}: Introduction'),
                    subtitle: Text(
                      index < 3 ? 'Completed' : 'Locked',
                      style: TextStyle(
                        color: index < 3 ? Colors.green : Colors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (index < 3) {
                        // Navigate to module content
                        Navigator.pushNamed(context, '/learning');
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
