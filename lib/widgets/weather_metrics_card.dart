import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherMetricsCard extends StatelessWidget {
  final int humidity;
  final double windSpeed;
  final int rainProbability;

  const WeatherMetricsCard({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMetricItem(
            icon: Icons.water_drop_rounded,
            value: '$humidity%',
            label: 'Kelembapan',
          ),
          Container(
            height: 36,
            width: 1,
            color: AppTheme.skyBlue.withValues(alpha: 0.3),
          ),
          _buildMetricItem(
            icon: Icons.air_rounded,
            value: '${windSpeed.round()} km/j',
            label: 'Angin',
          ),
          Container(
            height: 36,
            width: 1,
            color: AppTheme.skyBlue.withValues(alpha: 0.3),
          ),
          _buildMetricItem(
            icon: Icons.umbrella_rounded,
            value: '$rainProbability%',
            label: 'Peluang Hujan',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: AppTheme.navyBlue),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
