import 'package:get/get.dart';

import '../controllers/import_preview_controller.dart';

class ImportPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportPreviewController>(() => ImportPreviewController());
  }
}
