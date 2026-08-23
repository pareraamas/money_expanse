import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class SecondaryCard extends StatelessWidget {
  const SecondaryCard({
    super.key,
    required this.amount,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final String icon;
  final Color color;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 12),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color,
            child: SvgPicture.asset(icon, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 20, height: 20),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColor.gray3, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            amount.toRupiahString(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
