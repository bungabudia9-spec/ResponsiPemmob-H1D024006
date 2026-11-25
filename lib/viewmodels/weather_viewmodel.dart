import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../repositories/location_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationRepository _locationRepository = LocationRepository();

  Location? _selectedLocation;
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  Location? get selectedLocation => _selectedLocation;
  WeatherData? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Default location (Jakarta) kalau belum ada
  final Location defaultLocation = Location(
    name: 'Jakarta',
    latitude: -6.2146,
    longitude: 106.8451,
    country: 'Indonesia',
    admin1: 'DKI Jakarta',
  );

  // Inisialisasi: load lokasi terakhir atau default
  Future<void> initWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      final lastLoc = await _locationRepository.getLastLocation();
      _selectedLocation = lastLoc ?? defaultLocation;
      await fetchWeather(_selectedLocation!);
    } catch (e) {
      _isLoading = false;
      _weatherData = null;
      _errorMessage = 'Gagal memuat cuaca. Periksa koneksi lalu coba lagi.';
      notifyListeners();
    }
  }

  // Ambil cuaca berdasarkan lokasi
  Future<void> fetchWeather(Location location) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedLocation = location;
    notifyListeners();

    try {
      _weatherData = await _weatherService.getWeather(location.latitude, location.longitude);
      await _locationRepository.saveLastLocation(location);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _weatherData = null;
      _errorMessage = 'Gagal memuat cuaca. Periksa koneksi lalu coba lagi.';
      notifyListeners();
    }
  }

  // Refresh cuaca saat ini
  Future<void> refreshWeather() async {
    if (_selectedLocation != null) {
      await fetchWeather(_selectedLocation!);
    } else {
      await initWeather();
    }
  }
}
