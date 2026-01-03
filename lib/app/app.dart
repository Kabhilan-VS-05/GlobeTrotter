import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../auth/presentation/providers/auth_provider.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late AppRouter router;

  @override
  void initState() {
    super.initState();
    // Initialize router once
    final authState = ref.read(authProvider);
    router = AppRouter(authState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GlobeTrotter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
