import 'package:flutter/material.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/services/plant_service.dart';
import 'package:siramyuk/widgets/plant_card.dart';
import 'package:siramyuk/widgets/custom_filter_chip.dart';
import 'detail_plant_screen.dart';

class TanamanScreen extends StatefulWidget {
  final VoidCallback? onRefresh;

  const TanamanScreen({super.key, this.onRefresh});

  @override
  State<TanamanScreen> createState() => _TanamanScreenState();
}

class _TanamanScreenState extends State<TanamanScreen> {
  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF5F8F5);
  static const Color backgroundDark = Color(0xFF102210);

  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  final PlantService _plantService = PlantService();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Semua', 'Perlu Disiram', 'Sehat', 'Baru'];

  List<Plant> get _filteredPlants {
    List<Plant> plants = _plantService.getFilteredPlants(_selectedFilter);
    if (_searchQuery.isNotEmpty) {
      plants = plants
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (p.nickname?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }
    return plants;
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _navigateToDetail(Plant plant) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPlantScreen(plantId: plant.id),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? backgroundDark : backgroundLight;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final cardColor = isDarkMode ? const Color(0xFF1a331a) : Colors.white;

    final plants = _filteredPlants;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: subTextColor,
                        ),
                      ),
                      Text(
                        'Tanaman Saya',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_plantService.plants.length} Tanaman',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari tanaman...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF94A3B8),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                ),
              ),
            ),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: filter != _filters.last ? 12 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => _onFilterSelected(filter),
                      child: CustomFilterChip(
                        label: filter,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Plant List
            Expanded(
              child: plants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_florist_outlined,
                            size: 80,
                            color: subTextColor.withAlpha(128),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Tidak ada tanaman ditemukan'
                                : _selectedFilter != 'Semua'
                                ? 'Tidak ada tanaman dengan filter "$_selectedFilter"'
                                : 'Belum ada tanaman',
                            style: TextStyle(fontSize: 16, color: subTextColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tekan tombol + untuk menambahkan',
                            style: TextStyle(
                              fontSize: 14,
                              color: subTextColor.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: plants.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return GestureDetector(
                          onTap: () => _navigateToDetail(plant),
                          child: PlantCard(
                            plant: plant,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
