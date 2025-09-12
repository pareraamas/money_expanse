import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/date_formatter.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class MainTile extends StatelessWidget {
  const MainTile({super.key, required this.date, required this.expenses, required this.onUpdate});

  final DateTime date;
  final List<Expense> expenses;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(date.toHumanReadable(), style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),

        // Expense items
        ...expenses.map(
          (expense) => Container(
            height: 67,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 4))],
            ),
            child: ListTile(
              onTap: () => Get.toNamed(Routes.EXPANSE_CREATE, arguments: expense.id)?.then((value) {
                if (value == true) {
                  onUpdate.call();
                }
              }),
              leading: SvgPicture.asset(expense.expenseType.icon, color: expense.expenseType.color, width: 24, height: 24),
              title: Text(
                expense.name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: AppColor.gray1),
              ),
              trailing: Text(
                expense.price.toRupiahString(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 14, color: AppColor.gray1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
