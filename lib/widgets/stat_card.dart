import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color surfaceColor;
  final Color textMainColor;
  final Color borderColor;
  static const Color primaryColor = Color(0xFF0DF20D);

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.surfaceColor,
    required this.textMainColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textMainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
