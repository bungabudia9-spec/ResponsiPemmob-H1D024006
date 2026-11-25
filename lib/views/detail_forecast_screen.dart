import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../widgets/wave_header.dart';
import '../widgets/weather_metrics_card.dart';

class DetailForecastScreen extends StatelessWidget {
  final Location location;
  final WeatherData weatherData;

  const DetailForecastScreen({
    super.key,
    required this.location,
    required this.weatherData,
  });

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51 && code <= 67) return Icons.grain_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.umbrella_rounded;
    if (code >= 95) return Icons.flash_on_rounded;
    return Icons.cloud_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final current = weatherData.current;
    final subtitle = [location.admin1, location.country].where((e) => e != null && e.isNotEmpty).join(', ');
    final maxRainProb = weatherData.daily.isNotEmpty ? weatherData.daily[0].precipitationProbabilityMax : 0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Wave
            WaveHeader(
              height: 200,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Detail Prakiraan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Utama Cuaca Terkini (Putih)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.navyBlue.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getWeatherIcon(current.weatherCode),
                              size: 56,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${current.temperature.round()}°C',
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  weatherDescription(current.weatherCode),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 32, color: AppTheme.lightBlue),

                        // Metrik Detail Singkat
                        WeatherMetricsCard(
                          humidity: current.relativeHumidity,
                          windSpeed: current.windSpeed,
                          rainProbability: maxRainProb,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Prakiraan Cuaca Harian
                  const Text(
                    'Prakiraan Cuaca',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weatherData.daily.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherData.daily[index];
                      String formattedDate = forecast.date;
                      try {
                        final dateObj = DateTime.parse(forecast.date);
                        const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
                        const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                        final dayName = days[dateObj.weekday % 7];
                        formattedDate = '$dayName, ${dateObj.day} ${months[dateObj.month]}';
                      } catch (_) {}

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.navyBlue.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            Icon(_getWeatherIcon(forecast.weatherCode), color: Colors.amber, size: 26),
                            Text(
                              '${forecast.minTemperature.round()}° - ${forecast.maxTemperature.round()}°',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
