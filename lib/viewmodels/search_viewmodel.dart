import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../services/geocoding_service.dart';
import '../repositories/location_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final GeocodingService _geocodingService = GeocodingService();
  final LocationRepository _locationRepository = LocationRepository();

  String _query = '';
  List<Location> _searchResults = [];
  List<Location> _favorites = [];
  List<Location> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  Timer? _debounceTimer;

  String get query => _query;
  List<Location> get searchResults => _searchResults;
  List<Location> get favorites => _favorites;
  List<Location> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Load favorit dan riwayat saat awal buka
  Future<void> loadFavoritesAndHistory() async {
    try {
      _favorites = await _locationRepository.getFavorites();
      _history = await _locationRepository.getSearchHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat favorit/riwayat: $e');
    }
  }

  // Cari kota dengan debounce 500ms dan pengecekan query terbaru
  void searchCities(String queryText) {
    _query = queryText;
    if (_query.trim().isEmpty) {
      _debounceTimer?.cancel();
      _searchResults = [];
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounceTimer?.cancel();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final currentQuery = _query;
      try {
        final results = await _geocodingService.searchCity(currentQuery);
        if (_query == currentQuery) {
          _searchResults = results;
          _isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        if (_query == currentQuery) {
          _isLoading = false;
          _errorMessage = 'Tidak ada koneksi internet, coba lagi.';
          notifyListeners();
        }
      }
    });
  }

  // Cek apakah lokasi ada di favorit
  bool isFavorite(Location location) {
    return _favorites.contains(location);
  }

  // Toggle favorit
  Future<void> toggleFavorite(Location location) async {
    if (isFavorite(location)) {
      _favorites.remove(location);
    } else {
      _favorites.add(location);
    }
    await _locationRepository.saveFavorites(_favorites);
    notifyListeners();
  }

  // Hapus seluruh lokasi favorit
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _locationRepository.saveFavorites(_favorites);
    notifyListeners();
  }

  // Tambah ke riwayat pencarian
  Future<void> addToHistory(Location location) async {
    _history.remove(location);
    _history.insert(0, location);
    await _locationRepository.saveSearchHistory(_history);
    notifyListeners();
  }

  // Hapus riwayat pencarian
  Future<void> clearHistory() async {
    _history.clear();
    await _locationRepository.saveSearchHistory(_history);
    notifyListeners();
  }
}
