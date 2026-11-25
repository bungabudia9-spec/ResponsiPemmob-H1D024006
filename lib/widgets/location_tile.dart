import 'package:flutter/material.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';

class LocationTile extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const LocationTile({
    super.key,
    required this.location,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [location.admin1, location.country].where((e) => e != null && e.isNotEmpty).join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.skyBlue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on_rounded, color: AppTheme.navyBlue, size: 20),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              )
            : null,
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isFavorite ? Colors.amber : AppTheme.textSecondary,
            size: 24,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}
