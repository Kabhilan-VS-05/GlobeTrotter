import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../trips/presentation/screens/trip_list_screen.dart';
import '../../itinerary/presentation/screens/itinerary_screen.dart';
import '../../search/presentation/screens/search_screen.dart';
import '../../budget/presentation/screens/budget_screen.dart';
import '../../community/presentation/screens/community_screen.dart';
import '../../admin/presentation/screens/admin_dashboard_screen.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({super.key, required this.child});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      route: '/',
    ),
    NavigationItem(
      icon: Icons.travel_explore,
      label: 'Trips',
      route: '/trips',
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      route: '/search',
    ),
    NavigationItem(
      icon: Icons.account_balance_wallet,
      label: 'Budget',
      route: '/budget',
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Community',
      route: '/community',
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync current index with current route
    final location = GoRouterState.of(context).uri.path;
    setState(() {
      _currentIndex = _navigationItems.indexWhere(
        (item) => item.route == location,
      );
      if (_currentIndex == -1) {
        _currentIndex = 0; // Default to home if route not found
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(_navigationItems[index].route);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF667EEA),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        iconSize: 24,
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
