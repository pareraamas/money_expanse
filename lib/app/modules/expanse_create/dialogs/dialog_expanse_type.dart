import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/theme/app_color.dart';

Future<Category?> dialogExpanseType(
  BuildContext context,
  List<Category> categories,
) async {
  return await showModalBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Kategori",
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.gray1,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings_outlined, color: AppColor.gray2),
                        tooltip: 'Kelola Kategori',
                        onPressed: () => Get.toNamed('/category-list'),
                      ),
                      const CloseButton(),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == categories.length) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/category-create');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 28,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Buat Baru",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: AppColor.gray2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final item = categories[index];
                  return InkWell(
                    onTap: () => Get.back(result: item),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: item.color,
                          radius: 28,
                          child: SvgPicture.asset(
                            item.icon,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: AppColor.gray2,
                          ),
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
