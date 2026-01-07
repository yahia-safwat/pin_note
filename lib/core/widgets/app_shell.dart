import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/notes/presentation/pages/notes_list_page.dart';
import '../../../features/notifications/presentation/pages/notifications_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/tasks/presentation/pages/tasks_page.dart';

/// Main app shell with bottom navigation.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    NotesListPage(),
    TasksPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      // Bottom Navigation Bar with FAB cutout
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(theme),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        backgroundColor: const Color(0xFFD1C4E9), // Lavender
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6), // Light lavender
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home),
              _buildNavItem(
                1,
                Icons.calendar_today_outlined,
                Icons.calendar_today,
              ),
              const SizedBox(width: 64), // Space for FAB
              _buildNavItem(
                2,
                Icons.notifications_outlined,
                Icons.notifications,
              ),
              _buildNavItem(3, Icons.settings_outlined, Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          color: isSelected
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 26,
        ),
      ),
    );
  }

  void _onFabPressed(BuildContext context) {
    // Always navigate to create new note as requested
    context.go('/note/new');
  }
}
