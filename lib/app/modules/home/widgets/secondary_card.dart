import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class SecondaryCard extends StatelessWidget {
  const SecondaryCard({super.key, required this.amount, required this.type});

  final ExpenseType type;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(right: 12),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: type.color,
            child: SvgPicture.asset(type.icon, color: Colors.white, width: 20, height: 20),
          ),
          Text(type.label, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColor.gray3, fontSize: 12)),
          SizedBox(height: 5),
          Text(amount.toRupiahString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
