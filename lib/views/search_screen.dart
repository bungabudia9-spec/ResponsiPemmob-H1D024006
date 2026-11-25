import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../widgets/wave_header.dart';
import '../widgets/location_tile.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback? onSelectLocation;
  const SearchScreen({super.key, this.onSelectLocation});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Location> popularLocations = [
    Location(name: 'Jakarta', latitude: -6.2146, longitude: 106.8451, country: 'Indonesia', admin1: 'DKI Jakarta'),
    Location(name: 'Bandung', latitude: -6.9175, longitude: 107.6191, country: 'Indonesia', admin1: 'Jawa Barat'),
    Location(name: 'Surabaya', latitude: -7.2575, longitude: 112.7521, country: 'Indonesia', admin1: 'Jawa Timur'),
    Location(name: 'Semarang', latitude: -7.0051, longitude: 110.4381, country: 'Indonesia', admin1: 'Jawa Tengah'),
    Location(name: 'Yogyakarta', latitude: -7.7956, longitude: 110.3695, country: 'Indonesia', admin1: 'D.I. Yogyakarta'),
  ];

  final List<Location> allPopularLocations = [
    Location(name: 'Jakarta', latitude: -6.2146, longitude: 106.8451, country: 'Indonesia', admin1: 'DKI Jakarta'),
    Location(name: 'Bandung', latitude: -6.9175, longitude: 107.6191, country: 'Indonesia', admin1: 'Jawa Barat'),
    Location(name: 'Surabaya', latitude: -7.2575, longitude: 112.7521, country: 'Indonesia', admin1: 'Jawa Timur'),
    Location(name: 'Semarang', latitude: -7.0051, longitude: 110.4381, country: 'Indonesia', admin1: 'Jawa Tengah'),
    Location(name: 'Yogyakarta', latitude: -7.7956, longitude: 110.3695, country: 'Indonesia', admin1: 'D.I. Yogyakarta'),
    Location(name: 'Medan', latitude: 3.5952, longitude: 98.6722, country: 'Indonesia', admin1: 'Sumatera Utara'),
    Location(name: 'Makassar', latitude: -5.1477, longitude: 119.4327, country: 'Indonesia', admin1: 'Sulawesi Selatan'),
    Location(name: 'Denpasar', latitude: -8.6705, longitude: 115.2126, country: 'Indonesia', admin1: 'Bali'),
    Location(name: 'Palembang', latitude: -2.9761, longitude: 104.7754, country: 'Indonesia', admin1: 'Sumatera Selatan'),
    Location(name: 'Malang', latitude: -7.9666, longitude: 112.6326, country: 'Indonesia', admin1: 'Jawa Timur'),
    Location(name: 'Surakarta (Solo)', latitude: -7.5755, longitude: 110.8243, country: 'Indonesia', admin1: 'Jawa Tengah'),
    Location(name: 'Purbalingga', latitude: -7.3881, longitude: 109.3639, country: 'Indonesia', admin1: 'Jawa Tengah'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadFavoritesAndHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLocation(Location location) async {
    final searchVm = context.read<SearchViewModel>();
    final weatherVm = context.read<WeatherViewModel>();

    await searchVm.addToHistory(location);
    await weatherVm.fetchWeather(location);

    if (mounted) {
      widget.onSelectLocation?.call();
    }
  }

  void _showAllPopularLocationsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                'Semua Lokasi Populer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allPopularLocations.length,
                  itemBuilder: (context, index) {
                    final loc = allPopularLocations[index];
                    return LocationTile(
                      location: loc,
                      isFavorite: context.read<SearchViewModel>().isFavorite(loc),
                      onTap: () {
                        Navigator.pop(context);
                        _selectLocation(loc);
                      },
                      onFavoriteToggle: () {
                        context.read<SearchViewModel>().toggleFavorite(loc);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Navy Header
          WaveHeader(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Cari Lokasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Search Bar Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.navyBlue.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari nama kota...',
                      hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.navyBlue),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                context.read<SearchViewModel>().searchCities('');
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      context.read<SearchViewModel>().searchCities(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, searchVm, child) {
                if (searchVm.query.trim().isNotEmpty) {
                  if (searchVm.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.navyBlue));
                  }

                  if (searchVm.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          searchVm.errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (searchVm.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.skyBlue.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.map_outlined, size: 64, color: AppTheme.navyBlue),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Tidak ada hasil',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba cari nama kota lain',
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: searchVm.searchResults.length,
                    itemBuilder: (context, index) {
                      final loc = searchVm.searchResults[index];
                      final isFav = searchVm.isFavorite(loc);
                      return LocationTile(
                        location: loc,
                        isFavorite: isFav,
                        onTap: () => _selectLocation(loc),
                        onFavoriteToggle: () => searchVm.toggleFavorite(loc),
                      );
                    },
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lokasi Populer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        GestureDetector(
                          onTap: _showAllPopularLocationsBottomSheet,
                          child: const Text(
                            'Lihat Semua >',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.navyBlue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: popularLocations.map((loc) {
                        return ActionChip(
                          elevation: 1,
                          shadowColor: AppTheme.navyBlue.withValues(alpha: 0.06),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.skyBlue.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          label: Text(
                            loc.name,
                            style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          onPressed: () => _selectLocation(loc),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    if (searchVm.history.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Riwayat Pencarian',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          TextButton(
                            onPressed: () => searchVm.clearHistory(),
                            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...searchVm.history.map((loc) {
                        final isFav = searchVm.isFavorite(loc);
                        return LocationTile(
                          location: loc,
                          isFavorite: isFav,
                          onTap: () => _selectLocation(loc),
                          onFavoriteToggle: () => searchVm.toggleFavorite(loc),
                        );
                      }),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
