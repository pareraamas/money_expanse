import 'package:get/get.dart';

import '../controllers/expanse_create_controller.dart';

class ExpanseCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpanseCreateController>(
      () => ExpanseCreateController(),
    );
  }
}
