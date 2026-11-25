import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class GeocodingService {
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<Location>> searchCity(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse('$_baseUrl?name=${Uri.encodeComponent(query)}&count=10&language=id&format=json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>?;

        if (results == null) return [];

        return results.map((jsonItem) => Location.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Gagal mengambil data kota (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi saat mencari kota: $e');
    }
  }
}
