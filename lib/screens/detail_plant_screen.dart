import 'package:flutter/material.dart';
import 'package:siramyuk/components/circle_button.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/services/plant_service.dart';
import 'package:siramyuk/widgets/stat_card.dart';
import 'package:siramyuk/widgets/care_card.dart';
import 'package:siramyuk/widgets/plant_history_card.dart';
import 'add_plant_screen.dart';

class DetailPlantScreen extends StatefulWidget {
  final String plantId;

  const DetailPlantScreen({super.key, required this.plantId});

  @override
  State<DetailPlantScreen> createState() => _DetailPlantScreenState();
}

class _DetailPlantScreenState extends State<DetailPlantScreen> {
  final PlantService _plantService = PlantService();

  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF8FCF8);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2E1A);
  static const Color textMainLight = Color(0xFF0D1C0D);
  static const Color textMainDark = Color(0xFFE0EADD);
  static const Color textSecondaryLight = Color(0xFF499C49);
  static const Color textSecondaryDark = Color(0xFF0DF20D);

  Plant? get plant => _plantService.getPlantById(widget.plantId);

  void _toggleFavorite() {
    setState(() {
      _plantService.toggleFavorite(widget.plantId);
    });
    final currentPlant = plant;
    if (currentPlant != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentPlant.isFavorite
                ? '${currentPlant.nickname ?? currentPlant.name} ditambahkan ke favorit'
                : '${currentPlant.nickname ?? currentPlant.name} dihapus dari favorit',
            style: const TextStyle(
              color: Color(0xFF0D1C0D),
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  void _waterPlant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.water_drop, color: Colors.blue[400]),
            const SizedBox(width: 8),
            const Flexible(child: Text('Siram Tanaman')),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            'Apakah Anda sudah menyiram ${plant?.nickname ?? plant?.name}?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _plantService.waterPlant(widget.plantId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF0D1C0D)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${plant?.nickname ?? plant?.name} sudah disiram!',
                          style: const TextStyle(
                            color: Color(0xFF0D1C0D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
            ),
            child: const Text('Ya, Sudah'),
          ),
        ],
      ),
    );
  }

  void _editPlant() async {
    if (plant == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPlantScreen(plant: plant)),
    );
    if (result == true) {
      setState(() {});
      // Check if plant was deleted
      if (_plantService.getPlantById(widget.plantId) == null) {
        if (mounted) Navigator.pop(context, true);
      }
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final maxHeight = screenHeight * 0.6;

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Edit Tanaman'),
                    onTap: () {
                      Navigator.pop(context);
                      _editPlant();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      plant?.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: plant?.isFavorite == true ? Colors.red : null,
                    ),
                    title: Text(
                      plant?.isFavorite == true
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _toggleFavorite();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text('Bagikan'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Fitur berbagi segera hadir!',
                            style: TextStyle(
                              color: Color(0xFF0D1C0D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Hapus Tanaman',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: SingleChildScrollView(
          child: Text(
            'Apakah Anda yakin ingin menghapus ${plant?.nickname ?? plant?.name}?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _plantService.deletePlant(widget.plantId);
              Navigator.pop(context);
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tanaman berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotesDialog() {
    final TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        final screenHeight = MediaQuery.of(dialogContext).size.height;
        final maxDialogHeight = screenHeight * 0.5;

        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.sticky_note_2_outlined, color: Colors.blue),
              SizedBox(width: 8),
              Flexible(child: Text('Catatan')),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogHeight),
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Tambahkan catatan untuk tanaman ini:'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Tulis catatan...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Catatan berhasil disimpan! (Demo)',
                      style: TextStyle(
                        color: Color(0xFF0D1C0D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showGalleryDialog() {
    final currentPlant = plant;
    if (currentPlant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanaman tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        final screenSize = MediaQuery.of(dialogContext).size;
        final dialogWidth = screenSize.width * 0.8;
        final imageHeight = screenSize.height * 0.25;

        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.photo_library_outlined, color: Colors.purple),
              SizedBox(width: 8),
              Expanded(child: Text('Galeri')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: dialogWidth,
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      currentPlant.image,
                      fit: BoxFit.cover, // Pastikan gambar mengisi area
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Fitur galeri akan segera hadir!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPlant = plant;

    if (currentPlant == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Tanaman tidak ditemukan'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? backgroundDark : backgroundLight;
    final surfaceColor = isDarkMode ? surfaceDark : surfaceLight;
    final textMainColor = isDarkMode ? textMainDark : textMainLight;
    final textSecondaryColor = isDarkMode
        ? textSecondaryDark
        : textSecondaryLight;
    final borderColor = isDarkMode
        ? Colors.white.withAlpha(25)
        : Colors.black.withAlpha(13);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section with Immersive Image
                SizedBox(
                  height: 420,
                  child: Stack(
                    children: [
                      // Hero Image
                      Positioned.fill(
                        child: Image.network(
                          currentPlant.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey),
                        ),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                backgroundColor,
                                Colors.transparent,
                                Colors.black.withAlpha(77),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Navigation Overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleButton(
                                  icon: Icons.arrow_back,
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                                Row(
                                  children: [
                                    CircleButton(
                                      icon: currentPlant.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      onPressed: _toggleFavorite,
                                    ),
                                    const SizedBox(width: 12),
                                    CircleButton(
                                      icon: Icons.edit_outlined,
                                      onPressed: _editPlant,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Body
                Transform.translate(
                  offset: const Offset(0, -80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plant Title Block
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentPlant.nickname ?? currentPlant.name,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: textMainColor,
                                      height: 1.1,
                                    ),
                                  ),
                                  if (currentPlant.nickname != null)
                                    Text(
                                      currentPlant.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: isDarkMode
                                            ? Colors.grey[300]
                                            : textMainColor.withAlpha(204),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: surfaceColor.withAlpha(204),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                '${currentPlant.ageMonths ?? 0} bulan',
                                style: TextStyle(
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Location Badge
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              currentPlant.location,
                              style: TextStyle(
                                color: textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (currentPlant.isFavorite)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Favorit',
                                    style: TextStyle(
                                      color: Colors.red[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Quick Stats Row
                        Row(
                          children: [
                            StatCard(
                              icon: Icons.wb_sunny_outlined,
                              label: 'CAHAYA',
                              value: currentPlant.light ?? 'Indirect',
                              surfaceColor: surfaceColor,
                              textMainColor: textMainColor,
                              borderColor: borderColor,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              icon: Icons.thermostat,
                              label: 'SUHU',
                              value: currentPlant.temperature ?? '18-24°C',
                              surfaceColor: surfaceColor,
                              textMainColor: textMainColor,
                              borderColor: borderColor,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              icon: Icons.water_drop_outlined,
                              label: 'KELEMBABAN',
                              value: currentPlant.humidity ?? 'High',
                              surfaceColor: surfaceColor,
                              textMainColor: textMainColor,
                              borderColor: borderColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Care Schedule Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jadwal Perawatan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textMainColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Fitur kalender segera hadir!',
                                      style: TextStyle(
                                        color: Color(0xFF0D1C0D),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Lihat Kalender',
                                style: TextStyle(
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Water Card (Active)
                        GestureDetector(
                          onTap: _waterPlant,
                          child: CareCard(
                            icon: Icons.water_drop,
                            title: 'Penyiraman',
                            subtitle:
                                'Setiap ${currentPlant.wateringIntervalDays ?? 7} hari',
                            rightTopText: currentPlant.daysUntilWatering <= 0
                                ? 'Hari Ini!'
                                : currentPlant.daysUntilWatering == 1
                                ? 'Besok'
                                : '${currentPlant.daysUntilWatering} Hari',
                            rightBottomText:
                                'Terakhir: ${currentPlant.daysSinceLastWatered} hari lalu',
                            isActive: currentPlant.daysUntilWatering <= 1,
                            surfaceColor: surfaceColor,
                            textMainColor: textMainColor,
                            borderColor: borderColor,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Mist Card
                        CareCard(
                          icon: Icons.cloud_outlined,
                          title: 'Penyemprotan',
                          subtitle: 'Setiap 2 hari',
                          rightTopText: 'Hari Ini',
                          rightBottomText: 'Selesai 8 pagi',
                          surfaceColor: surfaceColor,
                          textMainColor: textMainColor,
                          borderColor: borderColor,
                          isDarkMode: isDarkMode,
                          rightTopIsBold: false,
                        ),
                        const SizedBox(height: 12),

                        // Fertilizer Card
                        CareCard(
                          icon: Icons.spa_outlined,
                          title: 'Pupuk',
                          subtitle: 'Setiap 4 minggu',
                          rightTopText: '12 Hari',
                          rightBottomText: 'Terakhir: 16 hari lalu',
                          surfaceColor: surfaceColor,
                          textMainColor: textMainColor,
                          borderColor: borderColor,
                          isDarkMode: isDarkMode,
                          rightTopIsBold: false,
                        ),
                        const SizedBox(height: 32),

                        // Plant History
                        Text(
                          'Riwayat Tanaman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textMainColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _showNotesDialog,
                                child: PlantHistoryCard(
                                  icon: Icons.sticky_note_2_outlined,
                                  title: 'Catatan',
                                  subtitle: '2 catatan baru',
                                  color: Colors.blue,
                                  surfaceColor: surfaceColor,
                                  textMainColor: textMainColor,
                                  borderColor: borderColor,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showGalleryDialog,
                                child: PlantHistoryCard(
                                  icon: Icons.photo_library_outlined,
                                  title: 'Galeri',
                                  subtitle: '14 foto',
                                  color: Colors.purple,
                                  surfaceColor: surfaceColor,
                                  textMainColor: textMainColor,
                                  borderColor: borderColor,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Location Map Mini
                        Container(
                          height: 128,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDarkMode ? surfaceDark : Colors.grey[200],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withAlpha(51),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    currentPlant.location,
                                    style: TextStyle(
                                      color: textMainColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              decoration: BoxDecoration(
                color: surfaceColor.withAlpha(230),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _waterPlant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: const Color(0xFF052905),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withAlpha(102),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Siram Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDarkMode ? surfaceDark : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.more_vert, color: textMainColor),
                      onPressed: _showMoreOptions,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
