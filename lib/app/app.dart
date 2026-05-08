import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';
import '../core/auth/secure_storage.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

class ShopifyApp extends StatelessWidget {
  const ShopifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        storage: SecureStorage(),
        authService: AppRoutes.authService,
      )..add(const AuthEvent.appStarted()),
      child: MaterialApp.router(
        title: 'Shopify Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF95BF47), // Shopify Green
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF95BF47),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
