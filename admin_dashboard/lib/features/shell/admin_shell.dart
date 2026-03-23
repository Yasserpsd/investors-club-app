import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/constants/admin_colors.dart';
import '../../app/admin_routes.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────
          _AdminSidebar(),

          // ── Main Content ────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top bar
                _AdminTopBar(),
                // Page content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 260,
      color: AdminColors.sidebarBg,
      child: Column(
        children: [
          // Logo area
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AdminColors.primaryGold.withOpacity(0.5),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.account_balance,
                        color: AdminColors.primaryGold,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نادي المستثمرين',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AdminColors.primaryGold,
                        ),
                      ),
                      Text(
                        'لوحة التحكم',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          fontSize: 11,
                          color: AdminColors.sidebarText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AdminColors.sidebarActive, height: 1),

          const SizedBox(height: 12),

          // Menu items
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'الرئيسية',
            route: AdminRoutes.dashboard,
            isActive: location == AdminRoutes.dashboard,
          ),
          _SidebarItem(
            icon: Icons.people_outlined,
            activeIcon: Icons.people,
            label: 'الأعضاء',
            route: AdminRoutes.members,
            isActive: location.startsWith('/members'),
          ),
          _SidebarItem(
            icon: Icons.business_center_outlined,
            activeIcon: Icons.business_center,
            label: 'العروض الاستثمارية',
            route: AdminRoutes.offers,
            isActive: location.startsWith('/offers'),
          ),
          _SidebarItem(
            icon: Icons.chat_outlined,
            activeIcon: Icons.chat,
            label: 'المحادثات',
            route: AdminRoutes.chat,
            isActive: location.startsWith('/chat'),
            badge: '3',
          ),
          _SidebarItem(
            icon: Icons.card_giftcard_outlined,
            activeIcon: Icons.card_giftcard,
            label: 'الإحالات',
            route: AdminRoutes.referrals,
            isActive: location == AdminRoutes.referrals,
          ),

          const Spacer(),

          // Logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                // TODO: Firebase sign out
                context.go(AdminRoutes.login);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AdminColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: AdminColors.error, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSansArabic',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AdminColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool isActive;
  final String? badge;

  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.isActive,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AdminColors.sidebarActive : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(
                    color: AdminColors.primaryGold.withOpacity(0.2),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: isActive
                    ? AdminColors.primaryGold
                    : AdminColors.sidebarText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AdminColors.sidebarTextActive
                        : AdminColors.sidebarText,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AdminColors.primaryGold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AdminColors.primaryDark,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AdminColors.cardBg,
        border: Border(
          bottom: BorderSide(color: AdminColors.cardBorder),
        ),
      ),
      child: Row(
        children: [
          // Search
          SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AdminColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AdminColors.cardBorder),
                ),
                filled: true,
                fillColor: AdminColors.pageBg,
              ),
              style: const TextStyle(
                fontFamily: 'IBMPlexSansArabic',
                fontSize: 13,
              ),
            ),
          ),

          const Spacer(),

          // Notifications
          IconButton(
            onPressed: () {},
            icon: Badge(
              smallSize: 8,
              backgroundColor: AdminColors.error,
              child: const Icon(
                Icons.notifications_outlined,
                color: AdminColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Admin avatar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.pageBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AdminColors.primaryGold,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: AdminColors.primaryDark,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'المدير',
                  style: TextStyle(
                    fontFamily: 'IBMPlexSansArabic',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
