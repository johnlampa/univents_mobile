import 'package:get/get.dart';
import 'package:univents_mobile/app/widgets/detailedview.dart';
import 'package:univents_mobile/app/views/login.dart';
import 'package:univents_mobile/app/views/dashboard.dart';
import 'package:univents_mobile/app/views/search.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(), // Login route
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const Dashboard(), // Dashboard route
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const Search(), // Dashboard route
    ),
    GetPage(
      name: AppRoutes.detailedView,
      page: () => const DetailedView(), // DetailedView route
    ),
  ];
}
