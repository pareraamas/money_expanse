// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:money_expense/gen/assets.gen.dart';

enum ExpenseType {
  FOOD('Makanan', Color(0xfff2c94c)),
  INTERNET("Internet", Color(0xff56CCF2)),
  EDUCATION("Education", Color(0xffF2994A)),
  GIFT("Hadiah", Color(0xffEB5757)),
  TRANSPORTATION("Transport", Color(0xff9B51E0)),
  SHOPPING("Belanja", Color(0xff27AE60)),
  HOME_APPLIANCES("Alat Rumah", Color(0xffBB6BD9)),
  SPORT("Olah Raga", Color(0xff2D9CDB)),
  ENTERTAINMENT("Hiburan", Color(0xff2F80ED));

  final String label;
  final Color color;

  const ExpenseType(this.label, this.color);

  // get icon
  String get icon => switch (this) {
    ExpenseType.FOOD => Assets.uilPizzaSlice,
    ExpenseType.INTERNET => Assets.uilRssAlt,
    ExpenseType.EDUCATION => Assets.uilBookOpen,
    ExpenseType.GIFT => Assets.uilGift,
    ExpenseType.TRANSPORTATION => Assets.uilCarSideview,
    ExpenseType.SHOPPING => Assets.uilShoppingCart,
    ExpenseType.HOME_APPLIANCES => Assets.uilHome,
    ExpenseType.SPORT => Assets.uilBasketball,
    ExpenseType.ENTERTAINMENT => Assets.uilClapperBoard,
  };

  // Convert string to ExpenseType
  static ExpenseType fromString(String value) {
    try {
      return ExpenseType.values.firstWhere((e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(), orElse: () => ExpenseType.FOOD);
    } catch (e) {
      return ExpenseType.FOOD;
    }
  }

  // Convert ExpenseType to string (just the enum name)
  String toShortString() {
    return toString().split('.').last;
  }
}
