import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/constants/app_colors.dart';
import '../../app/routes.dart';
import '../chat/services/chat_service.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.chat);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex(context),
          onTap: (index) => _onTap(context, index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: uid != null
                  ? _buildChatIcon(ref, uid, false)
                  : const Icon(Icons.chat_bubble_outline),
              activeIcon: uid != null
                  ? _buildChatIcon(ref, uid, true)
                  : const Icon(Icons.chat_bubble),
              label: 'الدعم',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatIcon(WidgetRef ref, String uid, bool isActive) {
    final unreadAsync = ref.watch(unreadCountProvider(uid));

    return unreadAsync.when(
      data: (count) {
        if (count == 0) {
          return Icon(
              isActive ? Icons.chat_bubble : Icons.chat_bubble_outline);
        }
        return Badge(
          label: Text(
            count > 9 ? '9+' : '$count',
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          child: Icon(
              isActive ? Icons.chat_bubble : Icons.chat_bubble_outline),
        );
      },
      loading: () =>
          Icon(isActive ? Icons.chat_bubble : Icons.chat_bubble_outline),
      error: (_, __) =>
          Icon(isActive ? Icons.chat_bubble : Icons.chat_bubble_outline),
    );
  }
}
