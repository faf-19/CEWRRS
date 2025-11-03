import 'package:cewrrs/presentation/bindings/home_binding.dart';
import 'package:cewrrs/presentation/bindings/login_binding.dart';
import 'package:cewrrs/presentation/bindings/maps_binding.dart';
import 'package:cewrrs/presentation/bindings/quick_report_binding.dart';
import 'package:cewrrs/presentation/bindings/report_binding.dart';
import 'package:cewrrs/presentation/bindings/sos_binding.dart';
import 'package:cewrrs/presentation/bindings/status_binding.dart';
import 'package:cewrrs/presentation/pages/IntroPage.dart';
import 'package:cewrrs/presentation/pages/SOS_page.dart';
import 'package:cewrrs/presentation/pages/auth/login_page.dart';
import 'package:cewrrs/presentation/pages/auth/otp_verification_page.dart';
import 'package:cewrrs/presentation/pages/auth/phone_input_page.dart';
import 'package:cewrrs/presentation/pages/home_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/report/quick_report_page.dart';
import 'package:cewrrs/presentation/pages/report/report_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:get/get.dart';
import '../../presentation/bindings/auth_binding.dart';

abstract class Routes {
  // --- Define all route names as static constants for clean access ---
  static const INTRO = '/intro';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PHONE = '/phone';
  static const VERIFY = '/verify';
  static const QUICK_REPORT = '/quick-report';
  static const REPORT = '/report';
  static const MAPS = '/maps';
  static const STATUS = '/status';
  static const SOS = '/sos';
}

class AppPages {
  // 1. Define the initial route for the app startup
  static const INITIAL =
      Routes.INTRO; // Change this to Routes.LOGIN or Routes.HOME after intro

  static final routes = [
    GetPage(
      name: Routes.INTRO,
      page: () => IntroPage(),
      // The IntroPage often doesn't need a binding if it only handles navigation/language selection
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: Routes.PHONE,
      page: () => const PhoneInputPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.VERIFY,
      page: () => const OtpVerificationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.QUICK_REPORT,
      page: () => const QuickReportPage(),
      binding: QuickReportBinding(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => ReportPage(),
      binding: ReportBinding(),
    ),
    GetPage(name: Routes.MAPS, page: () => MapsPage(), binding: MapsBinding()),
    GetPage(
      name: Routes.STATUS,
      page: () => StatusPage(),
      binding: StatusBinding(),
    ),
    GetPage(name: '/sos', page: () => SosPage(), binding: SosBinding()),
  ];
}
