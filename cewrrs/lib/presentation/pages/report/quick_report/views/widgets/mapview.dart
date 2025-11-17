import 'dart:async';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:cewrrs/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart' as loc;

class MapView extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();
  final QuuickReportController controllers = Get.put(QuuickReportController());
  final loc.Location location = loc.Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        title: Text(
          'Select Place',
          style: AppTextStyles.heading.copyWith(color: Appcolors.background),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Appcolors.background,
          ),
          onPressed: () => {Get.back()},
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controllers.targetLatitude!,
                  controllers.targetlongitude!,
                ),
                zoom: 18.0,
              ),
              onTap: controllers.updateMarker,
              compassEnabled: false,
              zoomControlsEnabled: false,
              markers: controllers.selectedLocation.value != null ? {
                Marker(
                  markerId: MarkerId("current"),
                  position: controllers.selectedLocation.value!,
                ),
              } : {},
            );
          }),
          locationButton(context),
          selectButton(),
        ],
      ),
    );
  }

  locationButton(BuildContext context) {
    return Positioned(
      left: 300,
      right: 0,
      bottom: 80,
      child: GestureDetector(
        onTap: () async {
          var status = await ph.Permission.location.status;

          if (!status.isGranted || status.isDenied) {
            // Ask user first
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Location Permission'),
                  content: Text(
                    'We need your location to assign the report to the nearest police station. This is optional — you can skip.',
                  ),
                  actions: [
                    TextButton(
                      child: Text('Skip'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('OK'),
                      onPressed: () async {
                        Navigator.pop(context);
                        if (!status.isGranted) {
                          status = await ph.Permission.location.request();
                        }
                        if (status.isGranted) getlocation();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            getlocation();
          }
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Appcolors.primary,
          ),
          child: Icon(Iconsax.location, color: Appcolors.accent),
        ),
      ),
    );
  }

  selectButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: AppButton(
          text: 'Select Location'.tr,
          onPressed: () {
            if (!controllers.isLocationSelelcted.value) {
              controllers.isLocationSelelcted(true);
              controllers.selectedLocation.value = LatLng(
                9.0096444,
                38.7409494,
              );
            }
            Get.back();
          },
          buttonColor: Appcolors.primary,
          textColor: Appcolors.accent,
        ),
      ),
    );
  }

  Future<void> getlocation() async {
    // Ensure location services enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Request permission via the plugin
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final userLocation = await location.getLocation();
    LatLng deviceLocation = LatLng(
      userLocation.latitude!,
      userLocation.longitude!,
    );

    controllers.targetLatitude = deviceLocation.latitude;
    controllers.targetlongitude = deviceLocation.longitude;

    // Move camera & update marker
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLng(deviceLocation));
      controllers.updateMarker(deviceLocation);
    });
  }
}
