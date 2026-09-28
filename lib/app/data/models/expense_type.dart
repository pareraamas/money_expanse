// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:wister_lite/gen/assets.gen.dart';

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
    ExpenseType.FOOD => Assets.iconCategory.uilPizzaSlice,
    ExpenseType.INTERNET => Assets.iconCategory.uilRssAlt,
    ExpenseType.EDUCATION => Assets.iconCategory.uilBookOpen,
    ExpenseType.GIFT => Assets.iconCategory.uilGift,
    ExpenseType.TRANSPORTATION => Assets.iconCategory.uilCarSideview,
    ExpenseType.SHOPPING => Assets.iconCategory.uilShoppingCart,
    ExpenseType.HOME_APPLIANCES => Assets.iconCategory.uilHome,
    ExpenseType.SPORT => Assets.iconCategory.uilBasketball,
    ExpenseType.ENTERTAINMENT => Assets.iconCategory.uilClapperBoard,
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
