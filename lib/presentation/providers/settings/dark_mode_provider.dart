import 'package:cinemapedia/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final preferencesProvider = KeyValueStorageServiceImpl();
  return ThemeNotifier(preferencesProvider: preferencesProvider);
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final KeyValueStorageServiceImpl preferencesProvider;
  ThemeNotifier({required this.preferencesProvider}) : super(ThemeMode.system);

  Future<void> toggleTheme() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    final preferences = await preferencesProvider.getSharedPreferences();

    await preferences.setString('theme_mode', state.name);
  }

  Future<void> loadTheme() async {
    final preferences = await preferencesProvider.getSharedPreferences();

    final savedTheme = preferences.getString('theme_mode');

    state = switch (savedTheme) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }
}
