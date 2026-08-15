import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchStorage {
  static const String _key = 'recent_searches_v1';
  static const int maxEntries = 5;

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <String>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<String>();
    } catch (_) {
      return <String>[];
    }
  }

  Future<List<String>> add(String username) async {
    final current = await load();
    current.removeWhere((e) => e.toLowerCase() == username.toLowerCase());
    current.insert(0, username);
    final trimmed = current.take(maxEntries).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(trimmed));
    return trimmed;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
