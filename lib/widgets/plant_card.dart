import 'package:flutter/material.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/components/status_badge.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;

  static const Color primaryColor = Color(0xFF0DF20D);

  const PlantCard({
    super.key,
    required this.plant,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              plant.image,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 96,
                height: 96,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        plant.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: subTextColor,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  plant.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (plant.status == 'needs_water')
                      StatusBadge(
                        icon: Icons.water_drop,
                        label: 'Hari ini',
                        bgColor: Colors.red[50]!,
                        textColor: Colors.red[600]!,
                      )
                    else if (plant.status == 'healthy')
                      StatusBadge(
                        icon: Icons.check_circle,
                        label: 'Sehat',
                        bgColor: primaryColor.withAlpha(51),
                        textColor: const Color(0xFF15803d), // green-700
                      )
                    else if (plant.status == 'attention')
                      StatusBadge(
                        icon: Icons.wb_sunny,
                        label: 'Kurang Cahaya',
                        bgColor: Colors.orange[50]!,
                        textColor: Colors.orange[700]!,
                      ),

                    if (plant.waterDays != null) ...[
                      const Spacer(),
                      Text(
                        'Air: ${plant.waterDays} hari',
                        style: TextStyle(
                          fontSize: 12,
                          color: subTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
