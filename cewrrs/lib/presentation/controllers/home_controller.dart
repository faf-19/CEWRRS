// lib/presentation/controllers/home_controller.dart
import 'package:cewrrs/presentation/pages/Settings_page.dart';
import 'package:cewrrs/presentation/pages/home_page.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/report_view.dart';
import 'package:cewrrs/presentation/pages/report/quick_report_page.dart';
import 'package:cewrrs/presentation/pages/report/staff_report_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Office {
  final String city;
  final String subcity;
  final String location;
  final String phone;
  final String email;

  Office({
    required this.city,
    required this.subcity,
    required this.location,
    required this.phone,
    required this.email,
  });
}

class HomeController extends GetxController {
  // ─────────────────────────────────────────────────────────────────────
  // 1. Storage & User
  // ─────────────────────────────────────────────────────────────────────
  final storage = GetStorage();
  final userEmail = ''.obs;
  final isMockUser = false.obs;

  // ─────────────────────────────────────────────────────────────────────
  // 2. Navigation State
  // ─────────────────────────────────────────────────────────────────────
  final selectedIndex = 0.obs;
  final tabHistory = <int>[0].obs;

  // ─────────────────────────────────────────────────────────────────────
  // 3. Dashboard State
  // ─────────────────────────────────────────────────────────────────────
  final RxString selectedTab = 'Weekly'.obs;
  final RxBool isExpense = true.obs;

  // ─────────────────────────────────────────────────────────────────────
  // 4. Pages for IndexedStack - Report page will be dynamic
  // ─────────────────────────────────────────────────────────────────────
  Widget get reportPage =>
      isMockUser.value ? StaffReportPage() : ReportView(isSign: false);
  List<Widget> get pages => [
    const HomePage(),
    // _getReportPage(), // This will be recalculated every time
    reportPage,
    MapsPage(),
    StatusPage(),
    SettingsView(),
  ];

  // ─────────────────────────────────────────────────────────────────────
  // 5. Office Data (SOS / Map)
  // ─────────────────────────────────────────────────────────────────────
  final offices = <Office>[].obs;
  final selectedCity = ''.obs;
  final selectedSubcity = ''.obs;

  List<String> get cities => offices.map((e) => e.city).toSet().toList();

  List<String> get subcities => offices
      .where((e) => e.city == selectedCity.value)
      .map((e) => e.subcity)
      .toSet()
      .toList();

  Office? get selectedOffice => offices.firstWhereOrNull(
    (e) => e.city == selectedCity.value && e.subcity == selectedSubcity.value,
  );

  // ─────────────────────────────────────────────────────────────────────
  // 6. Lifecycle
  // ─────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadMockData();
  }

  void _loadUser() {
    final user = storage.read('user');
    userEmail.value = user?['email'] ?? 'Guest';

    // Determine if user is from mock data or storage
    _determineUserSource();
  }

  void _determineUserSource() {
    final currentUserPhone = storage.read('current_user');

    // Define the exact mock users from your LoginController
    final mockUsers = {
      '+251911111111': 'password123',
      '+251922334455': 'secret456',
      '+251912121212': 'password1212',
    };

    // Check if current user is one of the mock users
    if (currentUserPhone != null && mockUsers.containsKey(currentUserPhone)) {
      isMockUser.value = true;
      print("User is MOCK USER: $currentUserPhone");
    } else {
      isMockUser.value = false;
      print("User is STORED USER: $currentUserPhone");
    }
  }

  Widget _getReportPage() {
    // Force re-determination of user source
    _determineUserSource();

    if (isMockUser.value) {
      print("Showing StaffReportPage for mock user");
      return StaffReportPage();
    } else {
      print("Showing ReportView for stored user");
      return ReportView(isSign: false);
    }
  }

  void _loadMockData() {
    offices.value = [
      Office(
        city: 'Addis Abeba',
        subcity: 'Bole',
        location: 'Bole Medhanialem, near XYZ Mall',
        phone: '+251 911 123456',
        email: 'bole.office@example.com',
      ),
      Office(
        city: 'Addis Abeba',
        subcity: 'Arada',
        location: 'Arada, Piassa Street 12',
        phone: '+251 911 654321',
        email: 'arada.office@example.com',
      ),
      Office(
        city: 'Adama',
        subcity: 'Kebele 03',
        location: 'Near Abadir Hospital',
        phone: '+251 912 000111',
        email: 'adama.office@example.com',
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────
  // 7. Dashboard Actions
  // ─────────────────────────────────────────────────────────────────────
  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void toggleExpenseIncome(bool expense) {
    isExpense.value = expense;
  }

  // ─────────────────────────────────────────────────────────────────────
  // 8. Navigation Actions
  // ─────────────────────────────────────────────────────────────────────
  void changeTab(int index) {
    if (selectedIndex.value != index) {
      tabHistory.add(index);
      selectedIndex.value = index;
    }
  }

  void goBackInTabFlow() {
    if (tabHistory.length > 1) {
      tabHistory.removeLast();
      selectedIndex.value = tabHistory.last;
    }
  }

  void logout() {
    storage.remove('user');
    storage.remove('current_user');
    storage.remove('is_logged_in');
    Get.offAllNamed('/login');
  }

  // Method to force refresh when needed
  void refreshUserType() {
    _determineUserSource();
    update(); // This will rebuild the UI
  }
}
