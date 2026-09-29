import 'package:get/get.dart';
import 'package:wister_lite/app/data/repositories/expense_repository.dart';
import 'package:wister_lite/app/data/services/home_widget_service.dart';
import 'package:wister_lite/app/data/services/share_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExpenseRepository>(ExpenseRepository(), permanent: true);
    Get.put<ShareService>(ShareService(), permanent: true);
    Get.put<HomeWidgetService>(HomeWidgetService(), permanent: true);
  }
}
