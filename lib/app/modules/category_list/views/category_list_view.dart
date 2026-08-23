import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/category_list_controller.dart';

class CategoryListView extends GetView<CategoryListController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kelola Kategori',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToCreate,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text('Belum ada kategori'));
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) return const SizedBox(height: 8);
                    final category = controller.categories[index ~/ 2];
                    return ListTile(
                      onTap: () => controller.goToEdit(category),
                      leading: CircleAvatar(
                        backgroundColor: category.color,
                        child: SvgPicture.asset(category.icon, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 20, height: 20),
                      ),
                      title: Text(category.label),
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    );
                  },
                  childCount: controller.categories.length * 2 - 1,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
