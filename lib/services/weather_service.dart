import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code&timezone=auto',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Gagal memuat data cuaca (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi saat memuat cuaca: $e');
    }
  }
}
