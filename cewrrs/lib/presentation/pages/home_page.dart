// lib/presentation/pages/home/home_page.dart
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/widgets/donut_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/widgets/classic_navbar.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:cewrrs/presentation/pages/report/report_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:cewrrs/presentation/pages/Settings_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static final List<Widget> _pages = [
    const _HomeDashboard(),
    ReportPage(),
    MapsPage(),
    StatusPage(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(controller: controller),
      bottomNavigationBar: ClassicNavBar(controller: controller),
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HomeDashboard – Dashboard + Emergency Contacts
// ─────────────────────────────────────────────────────────────────────────────
class _HomeDashboard extends GetView<HomeController> {
  const _HomeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.background,
      body: GetBuilder<HomeController>(
        init: controller, // ← forces onInit() to run first
        builder: (ctrl) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tabs
              _buildTabRow(),
              const SizedBox(height: 30),

              // 2. Donut Chart
              _buildDonutChartWithStats(),
              const SizedBox(height: 40),

              // 3. Bar Chart
              _buildBarChart(),
              const SizedBox(height: 20),

              // 4. View More
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Expense / Income Toggle
              _buildExpenseIncomeToggle(),
              const SizedBox(height: 30),

              // 6. Emergency Contacts
              _buildEmergencyContacts(ctrl),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────── Tabs ───────────────────────
  Widget _buildTabRow() {
    return Obx(
      () => Row(
        children: [
          _tabButton('Weekly', controller.selectedTab.value == 'Weekly'),
          _tabButton('Monthly', controller.selectedTab.value == 'Monthly'),
          _tabButton('Yearly', controller.selectedTab.value == 'Yearly'),
        ],
      ),
    );
  }

  Widget _tabButton(String title, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? Appcolors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Appcolors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────── Donut Chart ───────────────────────
  Widget _buildDonutChartWithStats() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: DonutChartPainter(
                sections: [
                  DonutSection(color: Appcolors.primary, percentage: 40),
                  DonutSection(color: Appcolors.accent, percentage: 30),
                  DonutSection(color: Appcolors.textLight, percentage: 20),
                  DonutSection(color: Colors.purple, percentage: 10),
                ],
              ),
            ),
          ),
          const Column(
            children: [
              Text(
                '1930\$',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'This week',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────── Bar Chart ───────────────────────
  Widget _buildBarChart() {
    final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final amounts = [400, 260, 300, 280, 150, 400, 200];
    final colors = [
      Colors.red,
      Colors.purple,
      Colors.yellow,
      Colors.green,
      Colors.green,
      Colors.red,
      Colors.purple,
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: amounts
              .map(
                (a) => Text(
                  '\$$a',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            7,
            (i) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: amounts[i] * 0.5,
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map(
                (d) => Text(
                  d,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ─────────────────────── Toggle ───────────────────────
  Widget _buildExpenseIncomeToggle() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _toggleButton('Expense', controller.isExpense.value),
            _toggleButton('Income', !controller.isExpense.value),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String title, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleExpenseIncome(title == 'Expense'),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Appcolors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────── Emergency Contacts ───────────────────────
  Widget _buildEmergencyContacts(HomeController ctrl) {
    final offices = ctrl.offices;
    if (offices.isEmpty) {
      return const Center(child: Text('No emergency contacts available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            'Emergency Contacts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final office = offices[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.redAccent),
                title: Text(
                  office.subcity,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(office.city),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.green),
                    const SizedBox(height: 4),
                    Text(office.phone, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                onTap: () => Get.snackbar(
                  'Contact',
                  'Call ${office.phone}',
                  backgroundColor: Appcolors.primary,
                  colorText: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
