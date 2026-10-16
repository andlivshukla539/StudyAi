import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/network/dio_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Fire both in parallel:
    //   1. Pre-warm server (wakes up Render from cold start + auto-detects LAN)
    //   2. Minimum 2-second splash display
    await Future.wait([
      ServerConfig().resolveAndWarm(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    if (mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'NeuRA',
                style: AppTypography.heading1.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
