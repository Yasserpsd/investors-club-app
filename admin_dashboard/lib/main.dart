import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'shared/constants/admin_theme.dart';
import 'app/admin_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    const ProviderScope(
      child: AdminDashboardApp(),
    ),
  );
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'لوحة تحكم نادي المستثمرين',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.theme,
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AdminRoutes.router,
    );
  }
}
