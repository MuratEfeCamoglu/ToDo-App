import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class CategoryScreen extends StatelessWidget {
  final List<Task> tasks;

  const CategoryScreen({super.key, required this.tasks});

  int _countFor(String category) =>
      tasks.where((t) => t.category == category).length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 8),
          const Text(
            'Organize your tasks',
            style: TextStyle(fontSize: 16, color: kPrimaryGreen),
          ),
          const SizedBox(height: 24),

          // Category Grid
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search,
                color: context.colors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {
        'name': 'Work',
        'tasks': _countFor('Work'),
        'icon': Icons.work_outline,
        'color': const Color(0xFFEDE7F6),
        'iconColor': const Color(0xFF7E57C2),
      },
      {
        'name': 'Personal',
        'tasks': _countFor('Personal'),
        'icon': Icons.favorite_outline,
        'color': const Color(0xFFFCE4EC),
        'iconColor': const Color(0xFFE91E63),
      },
      {
        'name': 'Health',
        'tasks': _countFor('Health'),
        'icon': Icons.monitor_heart_outlined,
        'color': const Color(0xFFE8F5E9),
        'iconColor': kPrimaryGreen,
      },
      {
        'name': 'Learning',
        'tasks': _countFor('Learning'),
        'icon': Icons.menu_book_outlined,
        'color': const Color(0xFFFFF8E1),
        'iconColor': const Color(0xFFFF9800),
      },
      {
        'name': 'Shopping',
        'tasks': _countFor('Shopping'),
        'icon': Icons.shopping_cart_outlined,
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF2196F3),
      },
      {
        'name': 'Travel',
        'tasks': _countFor('Travel'),
        'icon': Icons.flight_outlined,
        'color': const Color(0xFFFBE9E7),
        'iconColor': const Color(0xFFFF5722),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          name: category['name'] as String,
          tasks: category['tasks'] as int,
          icon: category['icon'] as IconData,
          color: category['color'] as Color,
          iconColor: category['iconColor'] as Color,
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required int tasks,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kOnPastel,
            ),
          ),
          if (tasks > 0) ...[
            const SizedBox(height: 4),
            Text(
              tasks == 1 ? '1 task' : '$tasks tasks',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
