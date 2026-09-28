import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Snackbar tunggal untuk semua layar. Warna & bentuk dari `snackBarTheme`,
/// jadi ikut light/dark. Pakai [actionLabel] + [onAction] untuk "Urungkan".
void showAppSnackBar(String message, {String? actionLabel, VoidCallback? onAction}) {
  final context = Get.context;
  if (context == null) return;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel != null && onAction != null ? SnackBarAction(label: actionLabel, onPressed: onAction) : null,
      ),
    );
}
