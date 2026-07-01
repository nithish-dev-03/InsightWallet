import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:insightwallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:insightwallet/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:insightwallet/features/auth/presentation/screens/login_screen.dart';
import 'package:insightwallet/features/auth/presentation/screens/register_screen.dart';
import 'package:insightwallet/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:insightwallet/features/auth/presentation/screens/reset_password_screen.dart';

import 'package:insightwallet/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:insightwallet/features/transactions/presentation/screens/transaction_list_screen.dart';
import 'package:insightwallet/features/reports/presentation/screens/reports_screen.dart';
import 'package:insightwallet/features/profile/presentation/screens/profile_screen.dart';
import 'package:insightwallet/features/notifications/presentation/screens/notification_list_screen.dart';

// ── Shell Scaffold with Bottom Navigation ──
class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/transactions')) return 1;
    if (location.startsWith('/reports')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/transactions');
        break;
      case 2:
        context.go('/reports');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}

class AppRouter {
  AppRouter._();

  static bool _isAuthenticated = false;

  static void setAuthenticated(bool value) => _isAuthenticated = value;

  static GoRouter create() {
    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      redirect: _authGuard,
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (_, __) => const LoginScreen(),
          // builder: (_, __) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/auth/register',
          name: 'register',
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-password',
          name: 'forgot-password',
          builder: (_, __) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/auth/reset-password',
          name: 'reset-password',
          builder: (_, state) => ResetPasswordScreen(
            token: state.pathParameters['token'] ?? '',
          ),
          routes: [
            GoRoute(
              path: ':token',
              name: 'reset-password-token',
              builder: (_, state) => ResetPasswordScreen(
                token: state.pathParameters['token'] ?? '',
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (_, __) => const NotificationListScreen(),
        ),
        ShellRoute(
          builder: (_, __, child) => _MainShell(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (_, __) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/transactions',
              name: 'transactions',
              builder: (_, __) => const TransactionListScreen(),
            ),
            GoRoute(
              path: '/reports',
              name: 'reports',
              builder: (_, __) => const ReportsScreen(),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  static FutureOr<String?> _authGuard(BuildContext context, GoRouterState state) {
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    final isSplash = state.matchedLocation == '/splash';
    final isOnboarding = state.matchedLocation == '/onboarding';

    if (isSplash) return null;

    if (!_isAuthenticated) {
      if (!isAuthRoute && !isOnboarding) {
        return '/auth/login';
      }
    } else {
      if (isAuthRoute) {
        return '/dashboard';
      }
    }

    return null;
  }
}
