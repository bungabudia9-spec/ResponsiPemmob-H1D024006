import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import '../widgets/wave_header.dart';

class FavoriteScreen extends StatefulWidget {
  final VoidCallback? onSelectLocation;
  const FavoriteScreen({super.key, this.onSelectLocation});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadFavoritesAndHistory();
    });
  }

  void _selectLocation(Location location) async {
    final weatherVm = context.read<WeatherViewModel>();
    await weatherVm.fetchWeather(location);
    if (mounted) {
      widget.onSelectLocation?.call();
    }
  }

  void _confirmClearAllFavorites(SearchViewModel searchVm) {
    if (searchVm.favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daftar favorit sudah kosong.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Semua Favorit?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus seluruh kota dari daftar favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await searchVm.clearAllFavorites();
              messenger.showSnackBar(
                const SnackBar(content: Text('Seluruh daftar favorit berhasil dihapus.')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchVm = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Navy Header
          WaveHeader(
            height: 150,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'Favorit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                      tooltip: 'Hapus Semua Favorit',
                      onPressed: () => _confirmClearAllFavorites(searchVm),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content List
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, searchVm, child) {
                final favorites = searchVm.favorites;

                if (favorites.isEmpty) {
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
                          child: const Icon(Icons.star_outline_rounded, size: 64, color: AppTheme.navyBlue),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada kota favorit',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tambahkan kota dari menu pencarian.',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final loc = favorites[index];
                    final subtitle = [loc.admin1, loc.country].where((e) => e != null && e.isNotEmpty).join(', ');

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.navyBlue.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () => _selectLocation(loc),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: AppTheme.skyBlue.withValues(alpha: 0.15),
                            child: const Icon(Icons.location_city_rounded, color: AppTheme.navyBlue, size: 28),
                          ),
                        ),
                        title: Text(
                          loc.name,
                          style: const TextStyle(
                            fontSize: 16,
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
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                          onPressed: () => searchVm.toggleFavorite(loc),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
