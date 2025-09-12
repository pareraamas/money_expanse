import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/theme/app_color.dart';

Future<ExpenseType?> dialogExpanseType(BuildContext context) async {
  return await showModalBottomSheet<ExpenseType>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.45,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Kategori",
                    style: GoogleFonts.sourceSans3(fontWeight: FontWeight.normal, fontSize: 14, color: AppColor.gray2),
                  ),
                  CloseButton(onPressed: () => Get.back()),
                ],
              ),
            ),

            Flexible(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5),
                itemCount: ExpenseType.values.length,
                itemBuilder: (context, index) {
                  final item = ExpenseType.values[index];
                  return InkWell(
                    onTap: () => Get.back(result: item),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: item.color,
                          radius: 24,
                          child: SvgPicture.asset(item.icon, color: Colors.white),
                        ),
                        Text(
                          item.label,
                          style: GoogleFonts.sourceSans3(fontWeight: FontWeight.normal, fontSize: 12, color: AppColor.gray3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
