import 'package:evidex/screens/analyze_screen.dart';
import 'package:evidex/screens/simulator_screen.dart';
import 'package:evidex/screens/stats_map_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class FloatingBottomNav extends StatefulWidget {
  const FloatingBottomNav({super.key});

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SimulatorScreen(),
    StatsMapScreen(),
    AnalyzeScreen(),
    Center(child: Text("Profile")),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.view_kanban_outlined,
    Icons.view_in_ar,
    Icons.analytics_outlined,
    Icons.settings,
  ];

  final List<String> labels = [
    "Home",
    "Simulator",
    "Stats",
    "Analysis",
    "Setting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: pages[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF134E95),
                Color(0xFF05182C),
              ],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF05182C).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(icons.length, (index) => _navItem(index)),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isSelected ? 50 : 24,
              height: isSelected ? 50 : 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                icons[index],
                color: isSelected ? const Color(0xFF1765BE) : Colors.white.withOpacity(0.9),
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[index],
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}