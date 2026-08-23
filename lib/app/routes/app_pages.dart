import 'package:get/get.dart';

import '../modules/expanse_create/bindings/expanse_create_binding.dart';
import '../modules/expanse_create/views/expanse_create_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/budget/bindings/budget_binding.dart';
import '../modules/budget/views/budget_view.dart';
import '../modules/statistik/bindings/statistik_binding.dart';
import '../modules/statistik/views/statistik_view.dart';
import '../modules/main_nav/bindings/main_nav_binding.dart';
import '../modules/main_nav/views/main_nav_view.dart';
import '../modules/category_create/bindings/category_create_binding.dart';
import '../modules/category_create/views/category_create_view.dart';
import '../modules/category_list/bindings/category_list_binding.dart';
import '../modules/category_list/views/category_list_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN_NAV;

  static final routes = [
    GetPage(name: _Paths.MAIN_NAV, page: () => const MainNavView(), binding: MainNavBinding()),
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.BUDGET, page: () => const BudgetView(), binding: BudgetBinding()),
    GetPage(name: _Paths.STATISTIK, page: () => const StatistikView(), binding: StatistikBinding()),
    GetPage(name: _Paths.EXPANSE_CREATE, page: () => const ExpanseCreateView(), binding: ExpanseCreateBinding()),
    GetPage(name: _Paths.CATEGORY_CREATE, page: () => const CategoryCreateView(), binding: CategoryCreateBinding()),
    GetPage(name: _Paths.CATEGORY_LIST, page: () => const CategoryListView(), binding: CategoryListBinding()),
  ];
}
