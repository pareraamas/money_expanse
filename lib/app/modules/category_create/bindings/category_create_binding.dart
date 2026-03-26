import 'package:get/get.dart';

import '../controllers/category_create_controller.dart';

class CategoryCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryCreateController>(
      () => CategoryCreateController(),
    );
  }
}
