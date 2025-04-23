import 'package:get/get.dart';
import 'package:univents_mobile/login.dart';
import 'package:univents_mobile/dashboard.dart';
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
  ];
}