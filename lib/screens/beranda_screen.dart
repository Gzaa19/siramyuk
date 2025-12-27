import 'package:flutter/material.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/services/plant_service.dart';
import 'package:siramyuk/services/auth_service.dart';
import 'detail_plant_screen.dart';
import 'tanaman_screen.dart';
import 'add_plant_screen.dart';
import 'login_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final PlantService _plantService = PlantService();
  final AuthService _authService = AuthService();

  static const Color primaryColor = Color(0xFF0DF20D);

  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAddPlant() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPlantScreen()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF1a331a) : Colors.white;
    final borderColor = isDarkMode
        ? const Color(0xFF1E293B)
        : const Color(0xFFF1F5F9);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _BerandaContent(
            plantService: _plantService,
            authService: _authService,
            onRefresh: () => setState(() {}),
          ),
          TanamanScreen(onRefresh: () => setState(() {})),
          const _PlaceholderScreen(title: 'Jadwal', icon: Icons.calendar_month),
          const _PlaceholderScreen(title: 'Profil', icon: Icons.person),
        ],
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
              heroTag: 'main_fab',
              onPressed: _navigateToAddPlant,
              backgroundColor: primaryColor,
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.black, size: 32),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(top: BorderSide(color: borderColor)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  Icons.home_rounded,
                  Icons.home_outlined,
                  'Beranda',
                  0,
                ),
                _buildNavItem(
                  Icons.local_florist,
                  Icons.local_florist_outlined,
                  'Tanaman',
                  1,
                ),
                _buildNavItem(
                  Icons.calendar_month,
                  Icons.calendar_month_outlined,
                  'Jadwal',
                  2,
                ),
                _buildNavItem(Icons.person, Icons.person_outline, 'Profil', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData activeIcon,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected ? primaryColor : Colors.grey[400],
            ),
            const SizedBox(height: 2),
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
      ),
    );
  }
}

// Beranda Content Widget
class _BerandaContent extends StatelessWidget {
  final PlantService plantService;
  final AuthService authService;
  final VoidCallback onRefresh;

  const _BerandaContent({
    required this.plantService,
    required this.authService,
    required this.onRefresh,
  });

  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF5F8F5);
  static const Color backgroundDark = Color(0xFF102210);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 15) return '🌤️';
    if (hour < 18) return '🌅';
    return '🌙';
  }

  List<Plant> get _plantsNeedWater {
    return plantService.plants.where((p) => p.status == 'needs_water').toList();
  }

  List<Plant> get _plantsNeedAttention {
    return plantService.plants.where((p) => p.status == 'attention').toList();
  }

  List<Plant> get _healthyPlants {
    return plantService.plants.where((p) => p.status == 'healthy').toList();
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
    final borderColor = isDarkMode
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(
                context,
                textColor,
                subTextColor,
                cardColor,
                borderColor,
              ),
              const SizedBox(height: 24),

              // Stats Overview Cards
              _buildStatsRow(textColor, subTextColor, cardColor, borderColor),
              const SizedBox(height: 24),

              // Today's Tasks Section
              if (_plantsNeedWater.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Siram Hari Ini',
                  Icons.water_drop,
                  Colors.blue,
                  '${_plantsNeedWater.length} tanaman',
                  Colors.red,
                  textColor,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _plantsNeedWater.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final plant = _plantsNeedWater[index];
                      return _buildWaterCard(
                        context,
                        plant,
                        cardColor,
                        textColor,
                        borderColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Tips Card
              _buildTipsCard(),
              const SizedBox(height: 24),

              // Healthy Plants Section
              if (_healthyPlants.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Tanaman Sehat',
                  Icons.check_circle,
                  primaryColor,
                  '${_healthyPlants.length} tanaman',
                  null,
                  textColor,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _healthyPlants.length > 5
                        ? 5
                        : _healthyPlants.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final plant = _healthyPlants[index];
                      return _buildMiniPlantCard(
                        context,
                        plant,
                        cardColor,
                        textColor,
                        borderColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Needs Attention Section
              if (_plantsNeedAttention.isNotEmpty) ...[
                _buildSectionHeader(
                  context,
                  'Perlu Perhatian',
                  Icons.warning_amber,
                  Colors.orange,
                  null,
                  null,
                  textColor,
                ),
                const SizedBox(height: 12),
                ..._plantsNeedAttention.map(
                  (plant) => _buildAttentionCard(
                    context,
                    plant,
                    cardColor,
                    textColor,
                    subTextColor,
                    borderColor,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Quick Actions Grid
              Text(
                'Aksi Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickActionsRow(context, cardColor, textColor, borderColor),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withAlpha(180)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()} ${_getGreetingEmoji()}',
                  style: TextStyle(fontSize: 14, color: subTextColor),
                ),
                Text(
                  'Pecinta Tanaman',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: textColor,
                  size: 22,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifikasi segera hadir!'),
                      backgroundColor: primaryColor,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showLogoutDialog(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(Icons.person_outline, color: textColor, size: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    Color textColor,
    Color subTextColor,
    Color cardColor,
    Color borderColor,
  ) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.local_florist,
          iconColor: primaryColor,
          bgColor: primaryColor.withAlpha(25),
          title: '${plantService.plants.length}',
          subtitle: 'Total Tanaman',
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
          borderColor: borderColor,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.water_drop,
          iconColor: Colors.blue,
          bgColor: Colors.blue.withAlpha(25),
          title: '${_plantsNeedWater.length}',
          subtitle: 'Perlu Disiram',
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
          borderColor: borderColor,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          icon: Icons.favorite,
          iconColor: Colors.red,
          bgColor: Colors.red.withAlpha(25),
          title: '${plantService.plants.where((p) => p.isFavorite).length}',
          subtitle: 'Favorit',
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
          borderColor: borderColor,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: subTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    String? badge,
    Color? badgeColor,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (badgeColor ?? iconColor).withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor ?? iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4158D0), Color(0xFFC850C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4158D0).withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.tips_and_updates,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips Hari Ini 💡',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Siram tanaman di pagi hari untuk hasil terbaik. Hindari menyiram saat matahari terik!',
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(
    BuildContext context,
    Plant plant,
    Color cardColor,
    Color textColor,
    Color borderColor,
  ) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPlantScreen(plantId: plant.id),
          ),
        );
        if (result == true) onRefresh();
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                plant.image,
                width: double.infinity,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.local_florist),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plant.nickname ?? plant.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                plantService.waterPlant(plant.id);
                onRefresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('${plant.nickname ?? plant.name} sudah disiram!'),
                      ],
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Siram',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlantCard(
    BuildContext context,
    Plant plant,
    Color cardColor,
    Color textColor,
    Color borderColor,
  ) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPlantScreen(plantId: plant.id),
          ),
        );
        if (result == true) onRefresh();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                plant.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.local_florist, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              plant.nickname ?? plant.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const Icon(Icons.check_circle, color: primaryColor, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildAttentionCard(
    BuildContext context,
    Plant plant,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    Color borderColor,
  ) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPlantScreen(plantId: plant.id),
          ),
        );
        if (result == true) onRefresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.orange.withAlpha(50)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                plant.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.local_florist),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname ?? plant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.orange[600], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Kurang Cahaya',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color borderColor,
  ) {
    return Row(
      children: [
        _buildActionCard(
          context: context,
          icon: Icons.calendar_month,
          label: 'Jadwal',
          color: Colors.purple,
          cardColor: cardColor,
          textColor: textColor,
          borderColor: borderColor,
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          context: context,
          icon: Icons.photo_library,
          label: 'Galeri',
          color: Colors.pink,
          cardColor: cardColor,
          textColor: textColor,
          borderColor: borderColor,
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          context: context,
          icon: Icons.bar_chart,
          label: 'Statistik',
          color: Colors.teal,
          cardColor: cardColor,
          textColor: textColor,
          borderColor: borderColor,
        ),
        const SizedBox(width: 12),
        _buildActionCard(
          context: context,
          icon: Icons.settings,
          label: 'Pengaturan',
          color: Colors.grey,
          cardColor: cardColor,
          textColor: textColor,
          borderColor: borderColor,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fitur $label segera hadir!'),
              backgroundColor: primaryColor,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Screen for Coming Soon tabs
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF102210)
        : const Color(0xFFF5F8F5);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF0DF20D).withAlpha(25),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 50, color: const Color(0xFF0DF20D)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Segera Hadir! 🚀',
              style: TextStyle(fontSize: 16, color: subTextColor),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0DF20D).withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0DF20D).withAlpha(50),
                ),
              ),
              child: const Text(
                'Fitur ini sedang dalam pengembangan',
                style: TextStyle(
                  color: Color(0xFF0DF20D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
