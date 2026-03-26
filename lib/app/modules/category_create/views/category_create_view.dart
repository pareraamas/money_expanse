import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/category_create_controller.dart';

class CategoryCreateView extends GetView<CategoryCreateController> {
  const CategoryCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Buat Kategori Baru',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label input
            const Text(
              'Nama Kategori',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.labelController,
              decoration: InputDecoration(
                hintText: 'Misal: Makan Siang',
                filled: true,
                focusColor: Colors.black,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              cursorColor: Colors.black,
            ),
            const SizedBox(height: 24),

            // Color Selection
            const Text(
              'Pilih Warna',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.availableColors.map((color) {
                  final isSelected = controller.selectedColor.value == color;
                  return GestureDetector(
                    onTap: () => controller.selectColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),

            // Icon Selection
            const Text(
              'Pilih Ikon',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.availableIcons.length,
                itemBuilder: (context, index) {
                  final iconPath = controller.availableIcons[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedIcon.value == iconPath;
                    return GestureDetector(
                      onTap: () => controller.selectIcon(iconPath),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? controller.selectedColor.value.withValues(
                                  alpha: 0.2,
                                )
                              : Colors.grey[100],
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: controller.selectedColor.value,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            iconPath,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? controller.selectedColor.value
                                  : Colors.grey[600]!,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveCategory(),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.selectedColor.value,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Simpan Kategori',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
