import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final Color backgroundColor;
  final VoidCallback onToggle;

  const TaskTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    required this.backgroundColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? kPrimaryGreen : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? kPrimaryGreen : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 16),
            // Task Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kOnPastel,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: kOnPastel,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
