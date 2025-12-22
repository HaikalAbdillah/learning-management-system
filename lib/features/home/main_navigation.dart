import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home_screen.dart';
import '../courses/my_classes_screen.dart';
import '../notifications/notification_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  late List<AnimationController> _controllers;

  final List<Widget> _pages = [
    const HomeScreen(),
    const MyClassesScreen(),
    const NotificationScreen(),
  ];

  final List<IconData> _icons = [Icons.home, Icons.school, Icons.notifications];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: index == 0 ? -0.125 : 0.0,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isEmpty
          ? const SizedBox()
          : IndexedStack(
              index: _currentIndex.clamp(0, _pages.length - 1),
              children: _pages,
            ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex.clamp(0, _icons.length - 1),
        height: 65,
        color: Colors.red,
        backgroundColor: Colors.white,
        items: List.generate(
          _icons.length,
          (index) => RotationTransition(
            turns: _controllers[index],
            child: Icon(_icons[index], color: Colors.white),
          ),
        ),
        onTap: (index) {
          if (index != _currentIndex && index >= 0 && index < _icons.length) {
            _controllers[_currentIndex].animateTo(0.0);
            _controllers[index].animateTo(-0.125);
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
