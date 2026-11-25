import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'theme/app_theme.dart';
import 'views/onboarding_screen.dart';
import 'views/main_navigation_screen.dart';
import 'repositories/location_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasSeenOnboarding = false;
  try {
    final repo = LocationRepository();
    hasSeenOnboarding = await repo.getHasSeenOnboarding();
  } catch (_) {
    hasSeenOnboarding = false;
  }

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, this.hasSeenOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        title: 'SkyWeather',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: hasSeenOnboarding ? const MainNavigationScreen() : const OnboardingScreen(),
      ),
    );
  }
}
