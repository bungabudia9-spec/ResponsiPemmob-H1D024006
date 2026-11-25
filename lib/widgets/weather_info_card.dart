import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.blueAccent),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
