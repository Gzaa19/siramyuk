import 'package:flutter/foundation.dart';
import 'package:siramyuk/models/plant.dart';

class PlantService extends ChangeNotifier {
  static final PlantService _instance = PlantService._internal();
  factory PlantService() => _instance;
  PlantService._internal();

  final List<Plant> _plants = [
    Plant(
      id: '1',
      name: 'Monstera Deliciosa',
      nickname: 'Monty',
      location: 'Ruang Tamu',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCPfN1_xmnJljjJHdyBNb9ODNZD8912TbfAyl7QTlz6qOp4xe8pVKrdllhGB_DvJxL6VIgz28tXxzOwrSZS34nJ-OFgkT1M9ha1uOAlZqRQUd1DjJc5tn7C_E4qljScv7i-0sH-hGMzRzo9rDst69pVKRyeoA7q6EmW4tvjXdiiMTc2TyGWYBbeYVCIFoiS9TIV7n3farAN1Z2DxjmcXD4RD45uNJIhBwyI45I25aMnNcIw70OcvBY5OLU8zOHw5o7YjYxb7NHQyVfP',
      status: 'needs_water',
      isFavorite: false,
      lastWatered: DateTime.now().subtract(const Duration(days: 6)),
      wateringIntervalDays: 7,
      light: 'Indirect',
      temperature: '18-24°C',
      humidity: 'High',
      ageMonths: 4,
    ),
    Plant(
      id: '2',
      name: 'Golden Barrel',
      nickname: 'Goldie',
      location: 'Balkon',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCwKL6fwRAcWNt0fQbw7VaskLffkBDfYB1X7iXKI9X_bwSHtJaqHfLQoa5cpJiftp9RgysiPqBKHFI3ADxNDuOztNwkLKUDhjPcFhvE_6Pwue9SwMNx_BHExzz0daknnZ8O_l22yb8GtRNFXnX0PBOwmRAIuY0OZml-d4vahtPAT6MXkmPm80ZJPR3olTpe3SoF3-ydVoQtJP61J-sr2zZTdYutEV3Y5XJX4wG0qrMVKzKC8fCcBwaDTLIzCEzYT0zy3iCVNJlRtVce',
      status: 'healthy',
      waterDays: 5,
      isFavorite: true,
      lastWatered: DateTime.now().subtract(const Duration(days: 2)),
      wateringIntervalDays: 14,
      light: 'Full Sun',
      temperature: '20-30°C',
      humidity: 'Low',
      ageMonths: 8,
    ),
    Plant(
      id: '3',
      name: 'Sansevieria',
      nickname: 'Sansa',
      location: 'Kamar Tidur',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBxD8aVznJkmNs-9jJSda_oFVjbLTRPRtMmYBdKwuLpjebXEfH09Ozq0wXjWUn-tkcWvuIRpN5iySCYyXy4vIVLSh_zqVPUOcWI4V8vuF4GrDxnAkq8JtPX_YFz5SdSTs2_sWrSRzThUUrqVBnWZ3bwMMcL1Z4-mAWtgDvK-_vdr3ifYXXMqKx1x6_OEP2XxH9pPGTOYnqO1iSxVX-vfQ-5UoMvfor8jnFzKvMHIP5bN7vBgN5WtmUvg42Z08hUwsTAHoM3rZ-ZdyWU',
      status: 'healthy',
      waterDays: 12,
      isFavorite: false,
      lastWatered: DateTime.now().subtract(const Duration(days: 5)),
      wateringIntervalDays: 21,
      light: 'Low light',
      temperature: '15-25°C',
      humidity: 'Medium',
      ageMonths: 12,
    ),
    Plant(
      id: '4',
      name: 'Ficus Lyrata',
      nickname: 'Figgy',
      location: 'Ruang Kerja',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA0VomZYpodjpgaaKxTgxQsLPu9o5xn7-13ag8biTG8biPJN1vYtv6AKn_XKDvJ9m06lfKLv-thQbk9Q3wEYKYkgc29SaZnXM0bhhrVOwdoTNzyrflLwMmfh1aix1Mqi3VykxJMzrWVEVESHMwQrYNI4tkLgFhaW2CNo1JnXlWjJO92l7pfIMt1erpzIh4mqsMpxlV3Z-gnQlZkr1R9xRCSwdJVpf-ChLqbSc0c39IMWG8jS52v_z9OCiZ8y3Ca21GBo-cioOVV-zZ_',
      status: 'attention',
      isFavorite: false,
      lastWatered: DateTime.now().subtract(const Duration(days: 3)),
      wateringIntervalDays: 10,
      light: 'Bright indirect',
      temperature: '18-24°C',
      humidity: 'High',
      ageMonths: 6,
    ),
  ];

  List<Plant> get plants => List.unmodifiable(_plants);

  List<Plant> getFilteredPlants(String filter) {
    switch (filter) {
      case 'Perlu Disiram':
        return _plants.where((p) => p.status == 'needs_water').toList();
      case 'Sehat':
        return _plants.where((p) => p.status == 'healthy').toList();
      case 'Baru':
        return _plants
            .where((p) => p.ageMonths != null && p.ageMonths! <= 3)
            .toList();
      default:
        return _plants;
    }
  }

  List<Plant> searchPlants(String query) {
    if (query.isEmpty) return _plants;
    return _plants
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.location.toLowerCase().contains(query.toLowerCase()) ||
              (p.nickname?.toLowerCase().contains(query.toLowerCase()) ??
                  false),
        )
        .toList();
  }

  Plant? getPlantById(String id) {
    try {
      return _plants.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void updatePlant(Plant plant) {
    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      _plants[index] = plant;
      notifyListeners();
    }
  }

  void deletePlant(String id) {
    _plants.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      final plant = _plants[index];
      _plants[index] = Plant(
        id: plant.id,
        name: plant.name,
        nickname: plant.nickname,
        location: plant.location,
        image: plant.image,
        status: plant.status,
        waterDays: plant.waterDays,
        isFavorite: !plant.isFavorite,
        lastWatered: plant.lastWatered,
        wateringIntervalDays: plant.wateringIntervalDays,
        light: plant.light,
        temperature: plant.temperature,
        humidity: plant.humidity,
        ageMonths: plant.ageMonths,
      );
      notifyListeners();
    }
  }

  void waterPlant(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index != -1) {
      final plant = _plants[index];
      _plants[index] = Plant(
        id: plant.id,
        name: plant.name,
        nickname: plant.nickname,
        location: plant.location,
        image: plant.image,
        status: 'healthy',
        waterDays: plant.wateringIntervalDays,
        isFavorite: plant.isFavorite,
        lastWatered: DateTime.now(),
        wateringIntervalDays: plant.wateringIntervalDays,
        light: plant.light,
        temperature: plant.temperature,
        humidity: plant.humidity,
        ageMonths: plant.ageMonths,
      );
      notifyListeners();
    }
  }
}
