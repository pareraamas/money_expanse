import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens/tokens.dart';

export 'tokens/tokens.dart';

/// Tema "Dompet yang Ceria": [light] dan [dark] dibangun dari token yang sama;
/// hanya lapis semantik ([AppColors]) yang berbeda.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  /// Mode tema aktif. Default `light` sampai semua layar di `modules/`
  /// bebas warna hardcoded (Fase 2), karena layar lama belum aman di dark.
  /// Review dark mode: `flutter run --dart-define=THEME_MODE=dark` (atau `system`).
  static ThemeMode get mode => switch (const String.fromEnvironment('THEME_MODE')) {
    'dark' => ThemeMode.dark,
    'system' => ThemeMode.system,
    _ => ThemeMode.light,
  };

  static SystemUiOverlayStyle overlayStyle(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      statusBarBrightness: brightness,
      systemNavigationBarColor: (dark ? AppColors.dark : AppColors.light).surfaceContainer,
      systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
    );
  }

  static ThemeData _build(AppColors c, Brightness brightness) {
    final scheme = c.toColorScheme(brightness);
    final text = AppTypography.textTheme.apply(bodyColor: c.ink, displayColor: c.ink);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: c.surface,
      canvasColor: c.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [c, AppComponentTokens.from(c)],

      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.page,
        titleTextStyle: text.titleLarge,
        iconTheme: IconThemeData(color: c.ink, size: 24),
        systemOverlayStyle: overlayStyle(brightness),
      ),

      cardTheme: CardThemeData(
        color: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
        labelStyle: text.bodyLarge?.copyWith(color: c.inkMuted),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: c.brand, fontWeight: FontWeight.w600),
        hintStyle: text.bodyLarge?.copyWith(color: c.inkMuted),
        helperStyle: text.bodySmall?.copyWith(color: c.inkMuted),
        errorStyle: text.bodySmall?.copyWith(color: c.danger),
        prefixIconColor: c.inkMuted,
        suffixIconColor: c.inkMuted,
        border: _inputBorder(c.outlineVariant),
        enabledBorder: _inputBorder(c.outlineVariant),
        focusedBorder: _inputBorder(c.brand, 2),
        errorBorder: _inputBorder(c.danger),
        focusedErrorBorder: _inputBorder(c.danger, 2),
        disabledBorder: _inputBorder(c.outlineVariant.withValues(alpha: 0.5)),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.brand,
          foregroundColor: c.onBrand,
          disabledBackgroundColor: c.ink.withValues(alpha: 0.12),
          disabledForegroundColor: c.ink.withValues(alpha: 0.38),
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          textStyle: text.labelLarge?.copyWith(fontSize: 16),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.brand,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          textStyle: text.labelLarge?.copyWith(fontSize: 16),
          side: BorderSide(color: c.outline),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.brand,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          textStyle: text.labelLarge,
          shape: const StadiumBorder(),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: c.ink, minimumSize: const Size.square(AppSpacing.minTouch)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: c.surfaceContainerLow,
          foregroundColor: c.inkMuted,
          selectedBackgroundColor: c.brandContainer,
          selectedForegroundColor: c.onBrandContainer,
          side: BorderSide(color: c.outlineVariant),
          textStyle: text.labelLarge,
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        elevation: 2,
        focusElevation: 2,
        hoverElevation: 3,
        highlightElevation: 1,
        shape: const CircleBorder(),
        extendedTextStyle: text.labelLarge,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: c.brandContainer,
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => text.labelMedium?.copyWith(color: s.contains(WidgetState.selected) ? c.ink : c.inkMuted),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(size: 24, color: s.contains(WidgetState.selected) ? c.onBrandContainer : c.inkMuted),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surfaceContainerLow,
        modalBackgroundColor: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: c.outline,
        dragHandleSize: const Size(32, 4),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetAll),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium?.copyWith(color: c.inkMuted),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: c.onInverseSurface),
        actionTextColor: c.brandContainer,
        elevation: 0,
        insetPadding: const EdgeInsets.all(AppSpacing.page),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.inputAll),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceContainerLow,
        selectedColor: c.brandContainer,
        disabledColor: c.ink.withValues(alpha: 0.12),
        checkmarkColor: c.onBrandContainer,
        labelStyle: text.labelLarge?.copyWith(color: c.ink),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: c.onBrandContainer),
        side: BorderSide(color: c.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chipAll),
        iconTheme: IconThemeData(color: c.inkMuted, size: 18),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: c.inkMuted,
        textColor: c.ink,
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodySmall?.copyWith(color: c.inkMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        minVerticalPadding: AppSpacing.s12,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      ),

      dividerTheme: DividerThemeData(color: c.outlineVariant, thickness: 1, space: 1),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.brand,
        linearTrackColor: c.surfaceContainerHighest,
        circularTrackColor: c.surfaceContainerHighest,
        linearMinHeight: 8,
        borderRadius: AppRadius.fullAll,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.brand,
        headerForegroundColor: c.onBrand,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetAll),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: c.inverseSurface, borderRadius: AppRadius.chipAll),
        textStyle: text.bodySmall?.copyWith(color: c.onInverseSurface),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.brand,
        selectionColor: c.brand.withValues(alpha: 0.24),
        selectionHandleColor: c.brand,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(borderRadius: AppRadius.inputAll, borderSide: BorderSide(color: color, width: width));
}

/// Akses singkat token dari widget: `context.colors.income`,
/// `context.components.balanceCard`, `context.text.titleLarge`.
extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppComponentTokens get components => Theme.of(this).extension<AppComponentTokens>()!;

  TextTheme get text => Theme.of(this).textTheme;
}
