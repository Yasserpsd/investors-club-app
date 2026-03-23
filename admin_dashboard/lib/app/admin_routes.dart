import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/admin_login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/members/screens/members_screen.dart';
import '../features/members/screens/member_detail_screen.dart';
import '../features/offers/screens/offers_screen.dart';
import '../features/offers/screens/offer_form_screen.dart';
import '../features/chat/screens/admin_chat_screen.dart';
import '../features/referrals/screens/referrals_screen.dart';
import '../features/shell/admin_shell.dart';

class AdminRoutes {
  AdminRoutes._();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String members = '/members';
  static const String memberDetail = '/members/:memberId';
  static const String offers = '/offers';
  static const String offerForm = '/offers/form';
  static const String offerEdit = '/offers/form/:offerId';
  static const String chat = '/chat';
  static const String chatWith = '/chat/:memberId';
  static const String referrals = '/referrals';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    debugLogDiagnostics: true,
    routes: [
      // Login
      GoRoute(
        path: login,
        builder: (context, state) => const AdminLoginScreen(),
      ),

      // Admin Shell with Sidebar
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: members,
            builder: (context, state) => const MembersScreen(),
          ),
          GoRoute(
            path: memberDetail,
            builder: (context, state) {
              final memberId = state.pathParameters['memberId']!;
              return MemberDetailScreen(memberId: memberId);
            },
          ),
          GoRoute(
            path: offers,
            builder: (context, state) => const OffersScreen(),
          ),
          GoRoute(
            path: offerForm,
            builder: (context, state) => const OfferFormScreen(),
          ),
          GoRoute(
            path: offerEdit,
            builder: (context, state) {
              final offerId = state.pathParameters['offerId']!;
              return OfferFormScreen(offerId: offerId);
            },
          ),
          GoRoute(
            path: chat,
            builder: (context, state) => const AdminChatScreen(),
          ),
          GoRoute(
            path: chatWith,
            builder: (context, state) {
              final memberId = state.pathParameters['memberId']!;
              return AdminChatScreen(selectedMemberId: memberId);
            },
          ),
          GoRoute(
            path: referrals,
            builder: (context, state) => const ReferralsScreen(),
          ),
        ],
      ),
    ],
  );
}
