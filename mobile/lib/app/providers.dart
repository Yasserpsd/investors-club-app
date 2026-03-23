import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/models/member_model.dart';
import '../features/auth/services/auth_service.dart';

// ── Language Provider ───────────────────────────────────
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('ar'));

  void setLanguage(String languageCode) {
    state = Locale(languageCode);
    _saveToPrefs(languageCode);
  }

  void toggleLanguage() {
    final newLang = state.languageCode == 'ar' ? 'en' : 'ar';
    state = Locale(newLang);
    _saveToPrefs(newLang);
  }

  bool get isArabic => state.languageCode == 'ar';

  Future<void> _saveToPrefs(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }
}

// ── Auth State Provider ─────────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ── Current Member Provider ─────────────────────────────
final currentMemberProvider = StreamProvider<MemberModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.read(authServiceProvider).currentMemberStream(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});
