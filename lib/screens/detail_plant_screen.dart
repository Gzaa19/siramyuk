import 'package:flutter/material.dart';
import 'package:siramyuk/components/circle_button.dart';
import 'package:siramyuk/widgets/stat_card.dart';
import 'package:siramyuk/widgets/care_card.dart';
import 'package:siramyuk/widgets/plant_history_card.dart';

class DetailPlantScreen extends StatelessWidget {
  const DetailPlantScreen({super.key});

  // Colors
  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF8FCF8);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2E1A);
  static const Color textMainLight = Color(0xFF0D1C0D);
  static const Color textMainDark = Color(0xFFE0EADD);
  static const Color textSecondaryLight = Color(0xFF499C49);
  static const Color textSecondaryDark = Color(0xFF0DF20D);
  static const Color borderColorDark = Colors.white10;
  static const Color borderColorLight = Colors.black12;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? backgroundDark : backgroundLight;
    final surfaceColor = isDarkMode ? surfaceDark : surfaceLight;
    final textMainColor = isDarkMode ? textMainDark : textMainLight;
    final textSecondaryColor = isDarkMode
        ? textSecondaryDark
        : textSecondaryLight;
    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.05);

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
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB5Hrj1twAlDJd7tSvn3EFYStidnAyqA2uGHJhuajFEiYSaJSBAnwUv8N8rOx-P6tQvN4QgciMoU8J8H5zpoycf0f2gjTsLIyoPJkcD2Yxt2GAzGLFBPJyaGSRicMR4J3a12PSwQs05PbpVqwkYK5yQm9-5BUtrdXxwfpyINJUKHiS3tXrbi4YLztET6plBAR5DGewCdybvsmY7Rm57WNVspIjEtDeMThxHf9TZyLyIAJBqwNFxx_j4oSghsjwJBWtWcFJE7db0EP5o',
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
                                Colors.black.withOpacity(0.3),
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
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Row(
                                  children: [
                                    CircleButton(
                                      icon: Icons.favorite_border,
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: 12),
                                    CircleButton(
                                      icon: Icons.edit_outlined,
                                      onPressed: () {},
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
                                    'Monty',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: textMainColor,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    'Monstera Deliciosa',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      color: isDarkMode
                                          ? Colors.grey[300]
                                          : textMainColor.withOpacity(0.8),
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
                                color: surfaceColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                '4 months old',
                                style: TextStyle(
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Quick Stats Row
                        Row(
                          children: [
                            StatCard(
                              icon: Icons.wb_sunny_outlined,
                              label: 'LIGHT',
                              value: 'Indirect',
                              surfaceColor: surfaceColor,
                              textMainColor: textMainColor,
                              borderColor: borderColor,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              icon: Icons.thermostat,
                              label: 'TEMP',
                              value: '18-24°C',
                              surfaceColor: surfaceColor,
                              textMainColor: textMainColor,
                              borderColor: borderColor,
                            ),
                            const SizedBox(width: 12),
                            StatCard(
                              icon: Icons.water_drop_outlined,
                              label: 'HUMID',
                              value: 'High',
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
                              'Care Schedule',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textMainColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'View Calendar',
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
                        CareCard(
                          icon: Icons.water_drop,
                          title: 'Watering',
                          subtitle: 'Every 7 days • 250ml',
                          rightTopText: 'Tomorrow',
                          rightBottomText: 'Last: 6 days ago',
                          isActive: true,
                          surfaceColor: surfaceColor,
                          textMainColor: textMainColor,
                          borderColor: borderColor,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 12),

                        // Mist Card
                        CareCard(
                          icon: Icons.cloud_outlined,
                          title: 'Misting',
                          subtitle: 'Every 2 days',
                          rightTopText: 'Today',
                          rightBottomText: 'Done 8am',
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
                          title: 'Fertilizer',
                          subtitle: 'Every 4 weeks',
                          rightTopText: '12 Days',
                          rightBottomText: 'Last: 16 days ago',
                          surfaceColor: surfaceColor,
                          textMainColor: textMainColor,
                          borderColor: borderColor,
                          isDarkMode: isDarkMode,
                          rightTopIsBold: false,
                        ),
                        const SizedBox(height: 32),

                        // Plant History
                        Text(
                          'Plant History',
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
                              child: PlantHistoryCard(
                                icon: Icons.sticky_note_2_outlined,
                                title: 'Notes',
                                subtitle: '2 new notes',
                                color: Colors.blue,
                                surfaceColor: surfaceColor,
                                textMainColor: textMainColor,
                                borderColor: borderColor,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: PlantHistoryCard(
                                icon: Icons.photo_library_outlined,
                                title: 'Gallery',
                                subtitle: '14 photos',
                                color: Colors.purple,
                                surfaceColor: surfaceColor,
                                textMainColor: textMainColor,
                                borderColor: borderColor,
                                isDarkMode: isDarkMode,
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
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://placeholder.pics/svg/300',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.4),
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
                                    'Living Room',
                                    style: const TextStyle(
                                      color: Colors.white,
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
                color: surfaceColor.withOpacity(0.9),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: const Color(0xFF052905),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: primaryColor.withOpacity(0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Water Now',
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
                      onPressed: () {},
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
