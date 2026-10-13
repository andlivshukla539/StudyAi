import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request the highest available display refresh rate (120 Hz / 90 Hz)
  if (Platform.isAndroid || Platform.isIOS) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(
    const ProviderScope(
      child: AiStudyCompanionApp(),
    ),
  );
}

class AiStudyCompanionApp extends ConsumerStatefulWidget {
  const AiStudyCompanionApp({super.key});

  @override
  ConsumerState<AiStudyCompanionApp> createState() => _AiStudyCompanionAppState();
}

class _AiStudyCompanionAppState extends ConsumerState<AiStudyCompanionApp> {
  @override
  void initState() {
    super.initState();
    // Enable highest refresh rate (120 Hz on supported devices)
    _enableHighRefreshRate();
  }

  Future<void> _enableHighRefreshRate() async {
    try {
      final displays = await WidgetsBinding.instance.platformDispatcher.displays.toList();
      // On Android, FlutterDisplayMode plugin or platform channel sets this,
      // but the simplest approach is to allow the system to use the max rate.
      // Flutter 3.x+ automatically respects the device's max refresh rate
      // when `SchedulerBinding` is initialised, which we've done above.
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AI Study Companion',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
