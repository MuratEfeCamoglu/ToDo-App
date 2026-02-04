import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 8),
          const Text(
            'Organize your tasks',
            style: TextStyle(fontSize: 16, color: Color(0xFF4CAF50)),
          ),
          const SizedBox(height: 24),

          // Category Grid
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search,
                color: Color(0xFF636E72),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
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
        'tasks': 12,
        'icon': Icons.work_outline,
        'color': const Color(0xFFEDE7F6),
        'iconColor': const Color(0xFF7E57C2),
      },
      {
        'name': 'Personal',
        'tasks': 8,
        'icon': Icons.favorite_outline,
        'color': const Color(0xFFFCE4EC),
        'iconColor': const Color(0xFFE91E63),
      },
      {
        'name': 'Health',
        'tasks': 5,
        'icon': Icons.monitor_heart_outlined,
        'color': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF4CAF50),
      },
      {
        'name': 'Learning',
        'tasks': 3,
        'icon': Icons.menu_book_outlined,
        'color': const Color(0xFFFFF8E1),
        'iconColor': const Color(0xFFFF9800),
      },
      {
        'name': 'Shopping',
        'tasks': 0,
        'icon': Icons.shopping_cart_outlined,
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF2196F3),
      },
      {
        'name': 'Travel',
        'tasks': 0,
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
              color: Color(0xFF2D3436),
            ),
          ),
          if (tasks > 0) ...[
            const SizedBox(height: 4),
            Text(
              '$tasks tasks',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
