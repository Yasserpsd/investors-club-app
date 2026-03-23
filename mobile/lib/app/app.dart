import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../shared/constants/app_theme.dart';
import 'providers.dart';
import 'routes.dart';

class InvestorsClubApp extends ConsumerStatefulWidget {
  final String initialLanguage;

  const InvestorsClubApp({
    super.key,
    required this.initialLanguage,
  });

  @override
  ConsumerState<InvestorsClubApp> createState() => _InvestorsClubAppState();
}

class _InvestorsClubAppState extends ConsumerState<InvestorsClubApp> {
  @override
  void initState() {
    super.initState();
    // Set initial language from saved preference
    Future.microtask(() {
      ref.read(languageProvider.notifier).setLanguage(widget.initialLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);

    return MaterialApp.router(
      // ── App Info ────────────────────────────────────
      title: 'نادي المستثمرين',
      debugShowCheckedModeBanner: false,

      // ── Theme ──────────────────────────────────────
      theme: AppTheme.lightTheme,

      // ── Localization ───────────────────────────────
      locale: locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Router ─────────────────────────────────────
      routerConfig: AppRoutes.router,
    );
  }
}
