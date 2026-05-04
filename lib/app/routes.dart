import 'package:go_router/go_router.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String products = '/products';
  static const String orders = '/orders';
  static const String analytics = '/analytics';
  static const String settings = '/settings';

  static final router = GoRouter(
    initialLocation: dashboard,
    routes: [
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      // Add other routes here as we implement the screens
    ],
  );
}
