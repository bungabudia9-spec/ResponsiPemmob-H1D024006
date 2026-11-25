import 'package:flutter/material.dart';
import '../models/weather.dart';

class ForecastItemCard extends StatelessWidget {
  final DailyForecast forecast;

  const ForecastItemCard({super.key, required this.forecast});

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy;
    if (code >= 51 && code <= 67) return Icons.grain;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.umbrella;
    if (code >= 95) return Icons.flash_on;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    String formattedDate = forecast.date;
    try {
      final dateObj = DateTime.parse(forecast.date);
      const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      formattedDate = '${days[dateObj.weekday - 1]}, ${dateObj.day} ${months[dateObj.month]}';
    } catch (_) {}

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              formattedDate,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              Icon(_getWeatherIcon(forecast.weatherCode), color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                weatherDescription(forecast.weatherCode),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              if (forecast.precipitationProbabilityMax > 0) ...[
                Icon(Icons.water_drop, size: 14, color: Colors.blue[300]),
                const SizedBox(width: 2),
                Text('${forecast.precipitationProbabilityMax}%', style: theme.textTheme.bodySmall),
                const SizedBox(width: 8),
              ],
              Text(
                '${forecast.maxTemperature.round()}° / ',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${forecast.minTemperature.round()}°',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
