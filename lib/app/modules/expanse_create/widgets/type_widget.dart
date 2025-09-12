import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_expense/app/theme/app_color.dart';

class TypeWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String iconPath;
  final Color iconColor;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const TypeWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.iconPath,
    required this.iconColor,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.borderTextInput),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prefix (icon)
            SvgPicture.asset(iconPath, color: iconColor, width: 24, height: 24),
            const SizedBox(width: 8),

            // Expanded TextField
            Expanded(
              child: Text(
                controller.text.isEmpty ? label : controller.text,
                style: TextStyle(fontSize: 14, color: controller.text.isEmpty ? Color(0xff828282) : AppColor.gray1),
              ),
            ),

            const SizedBox(width: 8),
            // Suffix (opsional)
            if (suffix != null) suffix!,
          ],
        ),
      ),
    );
  }
}
