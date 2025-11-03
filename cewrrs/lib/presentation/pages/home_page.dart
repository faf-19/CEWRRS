import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/widgets/classic_navbar.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cewrrs/presentation/pages/report/report_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:cewrrs/presentation/pages/SOS_page.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static final List<Widget> _pages = [
    const _HomeDashboard(), // Dashboard with map
    ReportPage(),
    MapsPage(),
    StatusPage(),
    SosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(controller: controller),
      bottomNavigationBar: ClassicNavBar(controller: controller),
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        )),
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '📍 Ethiopia Map Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(9.145, 40.4897),
              zoom: 6.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.cewrrs',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(9.03, 38.74),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: Colors.red),
                  ),
                  Marker(
                    point: LatLng(8.54, 39.27),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: Colors.blue),
                  ),
                  Marker(
                    point: LatLng(7.06, 38.47),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_on, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
