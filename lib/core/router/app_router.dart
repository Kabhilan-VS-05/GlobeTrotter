import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/register_screen.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../trips/presentation/screens/trip_list_screen.dart';
import '../../trips/presentation/screens/create_trip_screen.dart';
import '../../itinerary/presentation/screens/itinerary_screen.dart';
import '../../search/presentation/screens/search_screen.dart';
import '../../budget/presentation/screens/budget_screen.dart';
import '../../community/presentation/screens/community_screen.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  final AuthState authState;
  
  AppRouter(this.authState);

  late final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isGoingToLogin = state.uri.path == '/login' || state.uri.path == '/register';
      
      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }
      
      if (isAuthenticated && isGoingToLogin) {
        return '/';
      }
      
      return null;
    },
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main Navigation Routes
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/trips',
            name: 'trips',
            builder: (context, state) => const TripListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: 'create-trip',
                builder: (context, state) => const CreateTripScreen(),
              ),
              GoRoute(
                path: ':tripId',
                name: 'trip-details',
                builder: (context, state) {
                  final tripId = state.pathParameters['tripId']!;
                  return ItineraryScreen(tripId: tripId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/budget',
            name: 'budget',
            builder: (context, state) => const BudgetScreen(),
          ),
          GoRoute(
            path: '/community',
            name: 'community',
            builder: (context, state) => const CommunityScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/trips'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
