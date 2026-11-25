import 'package:flutter/material.dart';
import '../repositories/location_repository.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.deepNavy, AppTheme.navyBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icon.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'SkyWeather',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Cek cuaca, kapan saja\ndan di mana saja',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.navyBlue,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () async {
                      final repo = LocationRepository();
                      await repo.setHasSeenOnboarding(true);
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mulai',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
