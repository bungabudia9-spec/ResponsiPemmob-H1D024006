import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../models/weather.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../widgets/wave_header.dart';
import '../widgets/weather_metrics_card.dart';
import '../repositories/location_repository.dart';
import 'onboarding_screen.dart';
import 'detail_forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initWeather();
    });
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51 && code <= 67) return Icons.grain_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.umbrella_rounded;
    if (code >= 95) return Icons.flash_on_rounded;
    return Icons.cloud_rounded;
  }

  void _showQuickLocationPickerBottomSheet(WeatherViewModel vm) {
    final searchVm = context.read<SearchViewModel>();
    final locations = <Location>{...searchVm.favorites, ...searchVm.history}.toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Lokasi Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ganti lokasi secara cepat dari daftar favorit atau riwayatmu:',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              if (locations.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'Belum ada lokasi favorit atau riwayat tersimpan.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final loc = locations[index];
                      final isSelected = loc.name.toLowerCase() == (vm.selectedLocation?.name.toLowerCase() ?? '');

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSelected ? Colors.redAccent : AppTheme.navyBlue,
                        ),
                        title: Text(
                          loc.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppTheme.navyBlue : AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: loc.admin1 != null ? Text(loc.admin1!, style: const TextStyle(fontSize: 12)) : null,
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: AppTheme.navyBlue, size: 20)
                            : null,
                        onTap: () async {
                          Navigator.pop(bottomSheetContext);
                          await vm.fetchWeather(loc);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsBottomSheet(WeatherViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/icon.png', height: 36, width: 36, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SkyWeather App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      Text('Versi 1.0.0 • Open-Meteo REST API', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.skyBlue.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.refresh_rounded, color: AppTheme.navyBlue),
                ),
                title: const Text('Perbarui Data Cuaca', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                subtitle: const Text('Muat ulang data cuaca terkini dari API', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                onTap: () {
                  Navigator.pop(context);
                  vm.refreshWeather();
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('Memerbarui data cuaca...')),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.skyBlue.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.restart_alt_rounded, color: AppTheme.navyBlue),
                ),
                title: const Text('Lihat Halaman Onboarding', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                subtitle: const Text('Tampilkan kembali layar pembuka aplikasi', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  navigator.pop();
                  final repo = LocationRepository();
                  await repo.setHasSeenOnboarding(false);
                  navigator.pushReplacement(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<WeatherViewModel>(
        builder: (context, vm, child) {
          // 1. Loading State
          if (vm.isLoading && vm.weatherData == null) {
            return Column(
              children: [
                WaveHeader(
                  height: 380,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/icon.png', height: 28, width: 28, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SkyWeather',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const CircularProgressIndicator(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Mengambil data cuaca...',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // 2. Error State
          if (vm.errorMessage != null && vm.weatherData == null) {
            return Column(
              children: [
                WaveHeader(
                  height: 420,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/icon.png', height: 28, width: 28, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SkyWeather',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Gagal memuat data',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          vm.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.navyBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () => vm.refreshWeather(),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final weather = vm.weatherData;
          final location = vm.selectedLocation;
          if (weather == null || location == null) {
            return const Center(child: Text('Tidak ada data cuaca.'));
          }

          final current = weather.current;
          final conditionText = weatherDescription(current.weatherCode);
          final maxRainProb = weather.daily.isNotEmpty ? weather.daily[0].precipitationProbabilityMax : 0;

          // Format Waktu Sekarang
          String formattedDateTime = 'Hari ini';
          try {
            final now = DateTime.now();
            const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
            const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
            final dayStr = days[now.weekday % 7];
            final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
            formattedDateTime = '$dayStr, ${now.day} ${months[now.month]} ${now.year} • $timeStr';
          } catch (_) {}

          return RefreshIndicator(
            onRefresh: () => vm.refreshWeather(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Navy Wave Header
                  WaveHeader(
                    height: 380,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar: Title & Settings Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/icon.png', height: 32, width: 32, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'SkyWeather',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined, color: Colors.white),
                              tooltip: 'Pengaturan & Informasi',
                              onPressed: () => _showSettingsBottomSheet(vm),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Lokasi & Waktu (Interaktif)
                        GestureDetector(
                          onTap: () => _showQuickLocationPickerBottomSheet(vm),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  location.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 22),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formattedDateTime,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),

                        // Hero Cuaca: Icon + Suhu Besar + Kondisi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getWeatherIcon(current.weatherCode),
                              size: 72,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${current.temperature.round()}°C',
                                  style: const TextStyle(
                                    fontSize: 54,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  conditionText,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Terasa seperti ${current.apparentTemperature.round()}°C',
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Area Konten Utama (Putih / Background Light)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Satu Area Putih untuk 3 Informasi Detail
                        WeatherMetricsCard(
                          humidity: current.relativeHumidity,
                          windSpeed: current.windSpeed,
                          rainProbability: maxRainProb,
                        ),
                        const SizedBox(height: 24),

                        // Header Prakiraan 5 Hari ke Depan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Prakiraan 5 Hari ke Depan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailForecastScreen(
                                      location: location,
                                      weatherData: weather,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lihat Semua >',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.navyBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Daftar Kartu Prakiraan Harian (Horizontal)
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: weather.daily.length > 5 ? 5 : weather.daily.length,
                            itemBuilder: (context, index) {
                              final daily = weather.daily[index];
                              String dayLabel = 'Hari ${index + 1}';
                              try {
                                final dateObj = DateTime.parse(daily.date);
                                const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                                dayLabel = days[(dateObj.weekday - 1) % 7];
                              } catch (_) {}

                              return Container(
                                width: 85,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppTheme.skyBlue.withValues(alpha: 0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.navyBlue.withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      dayLabel,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Icon(
                                      _getWeatherIcon(daily.weatherCode),
                                      color: Colors.amber,
                                      size: 28,
                                    ),
                                    Text(
                                      '${daily.minTemperature.round()} - ${daily.maxTemperature.round()}°',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
