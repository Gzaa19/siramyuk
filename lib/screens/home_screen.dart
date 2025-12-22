import 'package:flutter/material.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/widgets/plant_card.dart';
import 'package:siramyuk/widgets/custom_filter_chip.dart';
import 'detail_plant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Colors
  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF5F8F5);
  static const Color backgroundDark = Color(0xFF102210);

  int _selectedIndex = 1; // Default to "Tanaman"

  final List<Plant> plants = [
    Plant(
      name: 'Monstera Deliciosa',
      location: 'Ruang Tamu',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCPfN1_xmnJljjJHdyBNb9ODNZD8912TbfAyl7QTlz6qOp4xe8pVKrdllhGB_DvJxL6VIgz28tXxzOwrSZS34nJ-OFgkT1M9ha1uOAlZqRQUd1DjJc5tn7C_E4qljScv7i-0sH-hGMzRzo9rDst69pVKRyeoA7q6EmW4tvjXdiiMTc2TyGWYBbeYVCIFoiS9TIV7n3farAN1Z2DxjmcXD4RD45uNJIhBwyI45I25aMnNcIw70OcvBY5OLU8zOHw5o7YjYxb7NHQyVfP',
      status: 'needs_water',
    ),
    Plant(
      name: 'Golden Barrel',
      location: 'Balkon',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCwKL6fwRAcWNt0fQbw7VaskLffkBDfYB1X7iXKI9X_bwSHtJaqHfLQoa5cpJiftp9RgysiPqBKHFI3ADxNDuOztNwkLKUDhjPcFhvE_6Pwue9SwMNx_BHExzz0daknnZ8O_l22yb8GtRNFXnX0PBOwmRAIuY0OZml-d4vahtPAT6MXkmPm80ZJPR3olTpe3SoF3-ydVoQtJP61J-sr2zZTdYutEV3Y5XJX4wG0qrMVKzKC8fCcBwaDTLIzCEzYT0zy3iCVNJlRtVce',
      status: 'healthy',
      waterDays: 5,
    ),
    Plant(
      name: 'Sansevieria',
      location: 'Kamar Tidur',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBxD8aVznJkmNs-9jJSda_oFVjbLTRPRtMmYBdKwuLpjebXEfH09Ozq0wXjWUn-tkcWvuIRpN5iySCYyXy4vIVLSh_zqVPUOcWI4V8vuF4GrDxnAkq8JtPX_YFz5SdSTs2_sWrSRzThUUrqVBnWZ3bwMMcL1Z4-mAWtgDvK-_vdr3ifYXXMqKx1x6_OEP2XxH9pPGTOYnqO1iSxVX-vfQ-5UoMvfor8jnFzKvMHIP5bN7vBgN5WtmUvg42Z08hUwsTAHoM3rZ-ZdyWU',
      status: 'healthy',
      waterDays: 12,
    ),
    Plant(
      name: 'Ficus Lyrata',
      location: 'Ruang Kerja',
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA0VomZYpodjpgaaKxTgxQsLPu9o5xn7-13ag8biTG8biPJN1vYtv6AKn_XKDvJ9m06lfKLv-thQbk9Q3wEYKYkgc29SaZnXM0bhhrVOwdoTNzyrflLwMmfh1aix1Mqi3VykxJMzrWVEVESHMwQrYNI4tkLgFhaW2CNo1JnXlWjJO92l7pfIMt1erpzIh4mqsMpxlV3Z-gnQlZkr1R9xRCSwdJVpf-ChLqbSc0c39IMWG8jS52v_z9OCiZ8y3Ca21GBo-cioOVV-zZ_',
      status: 'attention',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? backgroundDark : backgroundLight;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final cardColor = isDarkMode ? const Color(0xFF1a331a) : Colors.white;
    final borderColor = isDarkMode
        ? const Color(0xFF1E293B)
        : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
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
                            'Selamat Pagi,',
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: textColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari tanaman...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF94A3B8),
                      ),
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
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      const CustomFilterChip(label: 'Semua', isSelected: true),
                      const SizedBox(width: 12),
                      const CustomFilterChip(
                        label: 'Perlu Disiram',
                        isSelected: false,
                      ),
                      const SizedBox(width: 12),
                      const CustomFilterChip(label: 'Sehat', isSelected: false),
                      const SizedBox(width: 12),
                      const CustomFilterChip(label: 'Baru', isSelected: false),
                    ],
                  ),
                ),

                // Plant List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      100,
                    ), // Padding for Bottom Nav + FAB
                    itemCount: plants.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailPlantScreen(),
                            ),
                          );
                        },
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

            // Floating Action Button
            Positioned(
              bottom: 100, // Above bottom nav
              right: 20,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: primaryColor,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.black, size: 32),
              ),
            ),

            // Bottom Navigation (Custom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_outlined, 'Beranda', 0),
                    _buildNavItem(Icons.local_florist_outlined, 'Tanaman', 1),
                    _buildNavItem(Icons.calendar_month_outlined, 'Jadwal', 2),
                    _buildNavItem(Icons.person_outline, 'Profil', 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? primaryColor : Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
