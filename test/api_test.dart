import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/geocoding_service.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  test('Test Open-Meteo Geocoding API connection', () async {
    final geocodingService = GeocodingService();
    final results = await geocodingService.searchCity('Jakarta');

    expect(results, isNotEmpty);
    expect(results.first.name, 'Jakarta');
    expect(results.first.latitude, isNotNull);
    expect(results.first.longitude, isNotNull);
    // ignore: avoid_print
    print('Geocoding API Success: Found ${results.first.name} (${results.first.latitude}, ${results.first.longitude})');
  });

  test('Test Open-Meteo Weather Forecast API connection', () async {
    final weatherService = WeatherService();
    // Koordinat Jakarta
    final weatherData = await weatherService.getWeather(-6.2146, 106.8451);

    expect(weatherData, isNotNull);
    expect(weatherData.current.temperature, isA<double>());
    expect(weatherData.daily, isNotEmpty);
    // ignore: avoid_print
    print('Weather API Success: Current Temp = ${weatherData.current.temperature}°C, Daily Forecasts = ${weatherData.daily.length} days');
  });
}
