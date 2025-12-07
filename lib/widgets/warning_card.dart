import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? color;

  const WarningCard({
    super.key,
    this.icon = Icons.warning,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final materialColor = color != null && color is MaterialColor
        ? color as MaterialColor
        : Colors.amber;

    return Card(
      color: materialColor.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: materialColor),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}
