import 'package:flutter/material.dart';
import './admin_setup_page.dart';
import './admin_monitor_page.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int _selectedIndex = 0;

  // 👇 All your pages live here
  final List<Widget> _pages = const [
    AdminSetupPage(), // 🏠 Home/Setup page
    AdminMonitorPage(),
    Center(child: Text('Scan Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(), //
      backgroundColor: Colors.grey[100],
    );
  }

  // 👇 This builds the bottom navbar design
  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.list, "Queue", 1),
          _navItem(Icons.qr_code_scanner, "Scan", 2),
          _navItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ), // Adjusted padding
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.teal : Colors.grey[600],
              size: 28, // Increased icon size from default 24
            ),
            if (isActive) ...[
              const SizedBox(width: 8), // Slightly increased spacing
              Text(
                label,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16, // Added font size to match new proportions
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

