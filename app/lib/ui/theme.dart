import 'package:flutter/material.dart';

/// Fixed palette derived from the logo (no dynamic color).
/// Contrast pairs were checked against WCAG AA (docs/DECISIONS.md).
abstract final class Brand {
  static const blue = Color(0xFF2162B6);
  static const blueDark = Color(0xFF1F55B5);
  static const cyan = Color(0xFF59B6D7);
  static const cyanLight = Color(0xFF86DCE9);
  static const carrot = Color(0xFFF28C28);
  static const green = Color(0xFF4CAF50);
  static const navy = Color(0xFF0F1B2D);

  /// Header / FAB gradient. Text sits on the blue start (white text 6.9:1).
  static const headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
    colors: [blueDark, blue, cyan],
    stops: [0, 0.55, 1],
  );
}

/// Theme extension for colors Material 3 has no slot for.
@immutable
class ShopColors extends ThemeExtension<ShopColors> {
  const ShopColors({
    required this.success,
    required this.accent,
    required this.onAccent,
    required this.subtle,
  });

  final Color success;
  final Color accent;
  final Color onAccent;
  final Color subtle;

  static const light = ShopColors(
    success: Color(0xFF2E7D32),
    accent: Brand.carrot,
    onAccent: Color(0xFF1F1300),
    subtle: Color(0xFF5A6678),
  );
  static const dark = ShopColors(
    success: Brand.green,
    accent: Color(0xFFF5A65B),
    onAccent: Color(0xFF1F1300),
    subtle: Color(0xFFA9B6C8),
  );

  @override
  ShopColors copyWith({Color? success, Color? accent, Color? onAccent, Color? subtle}) =>
      ShopColors(
        success: success ?? this.success,
        accent: accent ?? this.accent,
        onAccent: onAccent ?? this.onAccent,
        subtle: subtle ?? this.subtle,
      );

  @override
  ShopColors lerp(ShopColors? other, double t) {
    if (other == null) return this;
    return ShopColors(
      success: Color.lerp(success, other.success, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
    );
  }
}

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Brand.blue,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD6E4F8),
  onPrimaryContainer: Color(0xFF0B2A57),
  secondary: Color(0xFF1E7FA3),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFCFF1F7),
  onSecondaryContainer: Color(0xFF00363F),
  tertiary: Color(0xFFB5530C),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFFFE0C2),
  onTertiaryContainer: Color(0xFF3A1A00),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF5F8FC),
  onSurface: Color(0xFF1A2433),
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Color(0xFFFFFFFF),
  surfaceContainer: Color(0xFFEDF2F8),
  surfaceContainerHigh: Color(0xFFE6ECF4),
  surfaceContainerHighest: Color(0xFFDFE6EF),
  onSurfaceVariant: Color(0xFF5A6678),
  outline: Color(0xFF8592A4),
  outlineVariant: Color(0xFFD3DBE6),
  inverseSurface: Color(0xFF243246),
  onInverseSurface: Color(0xFFE9EFF7),
  inversePrimary: Color(0xFF9CC2F5),
  shadow: Colors.black,
  scrim: Colors.black,
);

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7FB0F2),
  onPrimary: Brand.navy,
  primaryContainer: Color(0xFF1B4C8E),
  onPrimaryContainer: Color(0xFFD6E4F8),
  secondary: Brand.cyanLight,
  onSecondary: Color(0xFF00363F),
  secondaryContainer: Color(0xFF0E4B5C),
  onSecondaryContainer: Color(0xFFCFF1F7),
  tertiary: Color(0xFFF5A65B),
  onTertiary: Color(0xFF3A1A00),
  tertiaryContainer: Color(0xFF6E3A0A),
  onTertiaryContainer: Color(0xFFFFE0C2),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Brand.navy,
  onSurface: Color(0xFFE3ECF7),
  surfaceContainerLowest: Color(0xFF0A1422),
  surfaceContainerLow: Color(0xFF142235),
  surfaceContainer: Color(0xFF182638),
  surfaceContainerHigh: Color(0xFF1F2E42),
  surfaceContainerHighest: Color(0xFF26364C),
  onSurfaceVariant: Color(0xFFA9B6C8),
  outline: Color(0xFF6F7D90),
  outlineVariant: Color(0xFF2E3D52),
  inverseSurface: Color(0xFFE3ECF7),
  onInverseSurface: Color(0xFF1A2433),
  inversePrimary: Brand.blue,
  shadow: Colors.black,
  scrim: Colors.black,
);

ThemeData buildTheme(Brightness brightness) {
  final scheme = brightness == Brightness.light ? _lightScheme : _darkScheme;
  final shop = brightness == Brightness.light ? ShopColors.light : ShopColors.dark;
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final radius = BorderRadius.circular(16);
  return base.copyWith(
    extensions: [shop],
    scaffoldBackgroundColor: scheme.surface,
    textTheme: base.textTheme.copyWith(
      titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: scheme.outlineVariant)),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: scheme.outlineVariant)),
      focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: scheme.primary, width: 2)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

extension ShopTheme on BuildContext {
  ShopColors get shopColors => Theme.of(this).extension<ShopColors>()!;
}
