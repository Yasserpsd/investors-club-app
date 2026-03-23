import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Language Provider ───────────────────────────────────
// يتحكم في اللغة المختارة في التطبيق
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('ar'));

  void setLanguage(String languageCode) {
    state = Locale(languageCode);
  }

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      state = const Locale('en');
    } else {
      state = const Locale('ar');
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}

// ── Current Member Provider ─────────────────────────────
// TODO: سيتم ربطه مع Firebase Auth لاحقاً
// final currentMemberProvider = StreamProvider<MemberModel?>((ref) {
//   return ref.read(authServiceProvider).currentMemberStream();
// });

// ── Auth State Provider ─────────────────────────────────
// TODO: سيتم ربطه مع Firebase Auth لاحقاً
// final authStateProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });
