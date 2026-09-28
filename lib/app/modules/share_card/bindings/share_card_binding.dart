import 'package:get/get.dart';

import '../controllers/share_card_controller.dart';

class ShareCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareCardController>(() => ShareCardController());
  }
}
