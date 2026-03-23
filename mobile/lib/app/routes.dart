import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/offer_detail_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/referral/screens/referral_screen.dart';
import '../features/shell/main_shell.dart';

class AppRoutes {
  AppRoutes._();

  // ── Route Names ───────────────────────────────────
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String offerDetail = '/offer/:offerId';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String referral = '/referral';

  // ── Router ────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const SignUpScreen(),
      ),

      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: chat,
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Offer Detail (outside shell - full screen)
      GoRoute(
        path: offerDetail,
        builder: (context, state) {
          final offerId = state.pathParameters['offerId']!;
          return OfferDetailScreen(offerId: offerId);
        },
      ),

      // Referral (outside shell - full screen)
      GoRoute(
        path: referral,
        builder: (context, state) => const ReferralScreen(),
      ),
    ],

    // Redirect logic
    // TODO: ربط مع Firebase Auth للتحقق من حالة تسجيل الدخول
    // redirect: (context, state) {
    //   final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    //   final isOnAuth = state.matchedLocation == login ||
    //       state.matchedLocation == signUp ||
    //       state.matchedLocation == splash;
    //   if (!isLoggedIn && !isOnAuth) return login;
    //   if (isLoggedIn && isOnAuth) return home;
    //   return null;
    // },
  );
}
