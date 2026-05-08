import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/auth/auth_service.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/products/presentation/screens/products_screen.dart';
import '../features/orders/presentation/screens/orders_screen.dart';
import '../features/analytics/presentation/screens/analytics_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String analytics = '/analytics';
  static const String settings = '/settings';

  static final router = GoRouter(
    initialLocation: dashboard,
    // Provide the AuthService to listen to state changes
    refreshListenable: _authService,
    redirect: (context, state) {
      final isAuthenticated = _authService.isAuthenticated;
      final isLoggingIn = state.matchedLocation == login;

      if (!isAuthenticated && !isLoggingIn) {
        return login;
      }

      if (isAuthenticated && isLoggingIn) {
        return dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: 'login',
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'dashboard',
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        name: 'products',
        path: products,
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        name: 'orders',
        path: orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        name: 'analytics',
        path: analytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        name: 'settings',
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  static final AuthService _authService = AuthService();
  static AuthService get authService => _authService;
}
