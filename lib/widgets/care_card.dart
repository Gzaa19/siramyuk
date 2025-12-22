import 'package:flutter/material.dart';

class CareCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String rightTopText;
  final String rightBottomText;
  final Color surfaceColor;
  final Color textMainColor;
  final Color borderColor;
  final bool isDarkMode;
  final bool isActive;
  final bool rightTopIsBold;

  static const Color primaryColor = Color(0xFF0DF20D);

  const CareCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rightTopText,
    required this.rightBottomText,
    required this.surfaceColor,
    required this.textMainColor,
    required this.borderColor,
    required this.isDarkMode,
    this.isActive = false,
    this.rightTopIsBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? primaryColor.withOpacity(isDarkMode ? 0.2 : 0.3)
              : borderColor,
        ),
        boxShadow: isActive ? [] : null,
      ),
      child: Stack(
        children: [
          if (isActive)
            Positioned(
              left: -16,
              top: -16,
              bottom: -16,
              width: 6,
              child: Container(color: primaryColor),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isActive
                          ? primaryColor.withOpacity(0.1)
                          : (isDarkMode
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey[100]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isActive
                          ? primaryColor
                          : (isDarkMode ? Colors.grey[300] : Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textMainColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rightTopText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive || rightTopIsBold
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isActive ? primaryColor : textMainColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rightBottomText,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
