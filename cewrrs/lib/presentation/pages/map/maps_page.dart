import 'package:cewrrs/presentation/controllers/maps_controller.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../themes/colors.dart';

class MapsPage extends StatelessWidget {
  MapsPage({super.key});

  final MapsController controller = Get.put(MapsController());

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
      //appBar: CustomAppbar(controller: homeController),
      backgroundColor: Appcolors.background,
      body: Builder(
        builder: (context) {
          return Obx(() {
            if (controller.locations.isEmpty) {
              return const Center(child: Text("No incidents to display."));
            }

            // Auto-fit map to all pins
            final bounds = LatLngBounds.fromPoints(
              controller.locations
                  .map((loc) => LatLng(loc.lat, loc.lng))
                  .toList(),
            );

            return FlutterMap(
              options: MapOptions(
                bounds: bounds,
                boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(50)),
                interactiveFlags: InteractiveFlag.all,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: controller.locations.map((loc) {
                    final LatLng pos = LatLng(loc.lat, loc.lng);

                    return Marker(
                      point: pos,
                      width: 60,
                      height: 60,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            print("Tapped ${loc.label}");
                            _showPopup(
                              context,
                              loc.label,
                              loc.description,
                              loc.incidentTime,
                              loc.status,
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.red, width: 4),
                                ),
                              ),
                              const Icon(Icons.location_pin,
                                  color: Colors.red, size: 32),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          });
        },
      ),
    );
  }

 void _showPopup(BuildContext context, String label, String description,
    String time, String status) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📍 Incident Detail",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _infoRow("Location", label),
          _infoRow("Time", time),
          _infoRow("Status", status),

          const SizedBox(height: 12),
          const Text(
            "Description",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

Widget _infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
}
