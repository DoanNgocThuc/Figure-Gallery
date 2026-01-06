import 'package:figure_gallery/screens/feed_screen.dart';
import 'package:figure_gallery/screens/profile_screen.dart';
import 'package:figure_gallery/screens/setting_screen.dart';
import 'package:figure_gallery/screens/upload_screen.dart';
import 'package:figure_gallery/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    FeedScreen(),
    const Center(
      child: Text("Search Screen", style: TextStyle(color: Colors.white)),
    ),
    ProfileScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String get _appBarTitle {
    switch (_selectedIndex) {
      case 0:
        return "FIGURE FEED";
      case 1:
        return "SEARCH";
      case 2:
        return "PROFILE";
      case 3:
        return "SETTINGS";
      default:
        return "FIGURE GALLERY";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text(
          _appBarTitle,
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 2)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authViewModelProvider.notifier).logout();
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
            top: BorderSide(width: 1, color: Colors.grey.shade900),
          ),
        ),
        child: BottomAppBar(
          color: Color(0xFF1C1C1C),
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, index: 0),
                _buildNavItem(icon: Icons.search, index: 1),
                const SizedBox(width: 48),

                _buildNavItem(icon: Icons.person, index: 2),
                _buildNavItem(icon: Icons.settings, index: 3),
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

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        customBorder: const CircleBorder(), // Makes the splash round
        splashColor: colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : Colors.grey,
              size: isSelected ? 30 : 24,
            ),
            if (isSelected)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
