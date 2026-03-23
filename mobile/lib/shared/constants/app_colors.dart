import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Colors ──────────────────────────────────
  static const Color primaryDark = Color(0xFF1a1a2e);
  static const Color primaryGold = Color(0xFFC9A84C);
  static const Color primaryGoldLight = Color(0xFFE8D5A0);
  static const Color primaryGoldDark = Color(0xFFA8893D);

  // ── Background Colors ───────────────────────────────
  static const Color backgroundDark = Color(0xFF1a1a2e);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundCardDark = Color(0xFF252542);

  // ── Text Colors ─────────────────────────────────────
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnGold = Color(0xFF1a1a2e);
  static const Color textGold = Color(0xFFC9A84C);

  // ── Status Colors ───────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ── Border & Divider ────────────────────────────────
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFEEEEEE);

  // ── Chat Colors ─────────────────────────────────────
  static const Color chatMemberBubble = Color(0xFFC9A84C);
  static const Color chatAdminBubble = Color(0xFF252542);
  static const Color chatMemberText = Color(0xFF1a1a2e);
  static const Color chatAdminText = Color(0xFFFFFFFF);

  // ── Shimmer Colors ──────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── Gradients ───────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a1a2e),
      Color(0xFF16213e),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8D5A0),
      Color(0xFFC9A84C),
      Color(0xFFA8893D),
    ],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1a1a2e),
      Color(0xFF0f0f1e),
    ],
  );
}
