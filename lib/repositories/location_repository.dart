import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

class LocationRepository {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyLastLocation = 'last_location';
  static const String _keySearchHistory = 'search_history';
  static const String _keyOnboarding = 'has_seen_onboarding';

  // Simpan daftar lokasi favorit
  Future<void> saveFavorites(List<Location> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(_keyFavorites, jsonList);
  }

  // Baca daftar lokasi favorit
  Future<List<Location>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyFavorites);
    if (jsonList == null) return [];
    return jsonList.map((item) => Location.fromJson(json.decode(item))).toList();
  }

  // Simpan lokasi terakhir yang dipilih
  Future<void> saveLastLocation(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, json.encode(location.toJson()));
  }

  // Baca lokasi terakhir yang dipilih
  Future<Location?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyLastLocation);
    if (jsonString == null) return null;
    return Location.fromJson(json.decode(jsonString));
  }

  // Simpan riwayat pencarian (maksimal 10)
  Future<void> saveSearchHistory(List<Location> history) async {
    final prefs = await SharedPreferences.getInstance();
    final limited = history.length > 10 ? history.sublist(0, 10) : history;
    final jsonList = limited.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(_keySearchHistory, jsonList);
  }

  // Baca riwayat pencarian
  Future<List<Location>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keySearchHistory);
    if (jsonList == null) return [];
    return jsonList.map((item) => Location.fromJson(json.decode(item))).toList();
  }

  // Status Onboarding
  Future<bool> getHasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyOnboarding) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarding, value);
  }
}
