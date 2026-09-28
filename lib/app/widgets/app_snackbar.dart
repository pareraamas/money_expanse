import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/tokens/radius.dart';
import '../theme/tokens/spacing.dart';

/// Snackbar tunggal untuk semua layar: muncul di atas, tampil 2 detik.
/// Warna dari `snackBarTheme`, jadi ikut light/dark. Pakai [actionLabel] +
/// [onAction] untuk "Urungkan".
void showAppSnackBar(String message, {String? actionLabel, VoidCallback? onAction}) {
  final context = Get.context;
  if (context == null) return;
  final theme = Theme.of(context).snackBarTheme;

  if (Get.isSnackbarOpen) Get.closeAllSnackbars();

  Get.showSnackbar(
    GetSnackBar(
      messageText: Text(message, style: theme.contentTextStyle),
      mainButton: actionLabel != null && onAction != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onAction();
              },
              style: TextButton.styleFrom(foregroundColor: theme.actionTextColor),
              child: Text(actionLabel),
            )
          : null,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 2),
      backgroundColor: theme.backgroundColor ?? Theme.of(context).colorScheme.inverseSurface,
      borderRadius: AppRadius.input,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.s8),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: 14),
      dismissDirection: DismissDirection.up,
    ),
  );
}
