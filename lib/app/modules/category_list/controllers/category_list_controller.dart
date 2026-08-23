import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/routes/app_pages.dart';

class CategoryListController extends GetxController {
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  final categories = <Category>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    final fetched = await _repository.getCategories();
    categories.assignAll(fetched);
    isLoading.value = false;
  }

  Future<void> goToCreate() async {
    final result = await Get.toNamed(Routes.CATEGORY_CREATE);
    if (result == true) loadCategories();
  }

  Future<void> goToEdit(Category category) async {
    final result = await Get.toNamed(Routes.CATEGORY_CREATE, arguments: category);
    if (result == true) loadCategories();
  }
}
