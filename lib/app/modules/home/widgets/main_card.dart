import 'package:flutter/material.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class MainCard extends StatelessWidget {
  const MainCard({super.key, required this.title, required this.amount, required this.color});

  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 14)),
            SizedBox(height: 12),
            Text(
              amount.toRupiahString(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
