import 'package:figure_gallery/screens/feed_screen.dart';
import 'package:figure_gallery/screens/profile_screen.dart';
import 'package:figure_gallery/screens/upload_screen.dart';
import 'package:figure_gallery/services/auth_service.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[FeedScreen(), ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "FIGURE FEED" : "MY COLLECTION",
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await AuthService().signOut();
              },
            ),
        ],
      ),

      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        elevation: 10,
        shape: CircleBorder(side: BorderSide(color: Colors.black, width: 3)),
        child: Icon(Icons.add_a_photo, color: Colors.white, size: 28),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UploadScreen()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),

        child: BottomAppBar(
          color: Color(0xFF1C1C1C),
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, index: 0),
                _buildNavItem(icon: Icons.person, index: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? colorScheme.primary : Colors.grey,
            size: isSelected ? 30 : 24,
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
