import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_screen.dart';
import '../courses/my_classes_screen.dart';
import '../notifications/notification_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int? _pressedIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    MyClassesScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  Widget _buildAnimatedIcon(IconData icon, int index) {
    final isActive = _currentIndex == index;
    final isPressed = _pressedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.red.shade300 : Colors.red,
        shape: BoxShape.circle,
      ),
      child: Transform.rotate(
        angle: isActive ? 0.785 : 0, // 45 degrees when active
        child: Transform.scale(
          scale: isPressed ? 1.3 : 1.0,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  void _onIconPressed(int index) {
    // Set pressed state
    setState(() {
      _pressedIndex = index;
    });

    // Reset after animation completes
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _pressedIndex == index) {
        setState(() {
          _pressedIndex = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 65,
        color: Colors.red,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.red.shade200,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: [
          _buildAnimatedIcon(Icons.home, 0),
          _buildAnimatedIcon(Icons.school, 1),
          _buildAnimatedIcon(Icons.notifications, 2),
          _buildAnimatedIcon(Icons.person, 3),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onIconPressed(index);
        },
      ),
    );
  }
}
