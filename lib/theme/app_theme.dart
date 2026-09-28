import 'package:flutter/material.dart';

const Color kPrimaryGreen = Color(0xFF4CAF50);

/// Text color used on pastel cards; the cards keep their light background in
/// both themes, so their text stays dark.
const Color kOnPastel = Color(0xFF2D3436);

/// Colors that change between light and dark mode.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color divider;

  const AppColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.divider,
  });

  static const light = AppColors(
    textPrimary: Color(0xFF2D3436),
    textSecondary: Color(0xFF636E72),
    textMuted: Color(0xFF9E9E9E),
    background: Colors.white,
    surface: Color(0xFFFAFAFA),
    surfaceVariant: Color(0xFFF5F5F5),
    border: Color(0xFFE0E0E0),
    divider: Color(0xFFEEEEEE),
  );

  static const dark = AppColors(
    textPrimary: Color(0xFFECEFF1),
    textSecondary: Color(0xFFB0BEC5),
    textMuted: Color(0xFF8A9499),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    surfaceVariant: Color(0xFF2A2A2A),
    border: Color(0xFF3A3A3A),
    divider: Color(0xFF2E2E2E),
  );

  @override
  AppColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? divider,
  }) {
    return AppColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      border: border ?? this.border,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

ThemeData buildAppTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? AppColors.dark
      : AppColors.light;
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryGreen,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: colors.background,
    fontFamily: 'Roboto',
    useMaterial3: true,
    extensions: [colors],
  );
}
