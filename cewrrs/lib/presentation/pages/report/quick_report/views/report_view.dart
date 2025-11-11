import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendphoto.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendvideo.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendaudio.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendfile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location_pkg;
import 'package:geocoding/geocoding.dart';

class ReportView extends StatefulWidget {
  final int initialTabIndex;
  final bool isSign;

  const ReportView({super.key, this.initialTabIndex = 0, required this.isSign});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  final QuuickReportController reportController = Get.put(QuuickReportController());

  // Location and time selection
  TextEditingController descriptionController = TextEditingController();
  String selectedTimeText = 'Time';
  String selectedPlaceText = 'Place';
  String currentAddress = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    // Listen to controller changes
    // ever(reportController.selectedTime, _updateTimeDisplay);
    // ever(reportController.selectedLocation, _updateLocationDisplay);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          'Quick Report',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simple TabBar
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: const BoxDecoration(),
                  labelPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(icon: Icon(Icons.camera, color: Colors.blue)),
                    Tab(icon: Icon(Icons.videocam, color: Colors.blue)),
                    Tab(icon: Icon(Icons.mic, color: Colors.blue)),
                    Tab(icon: Icon(Icons.attach_file, color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 80),

              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SendPhotoWidget(reportController: reportController),
                    SendVideoWidget(reportController: reportController, isSignLangauge: widget.isSign),
                    SendaudioWidget(reportController: reportController),
                    SendFileWidget(reportController: reportController),
                  ],
                ),
              ),

              // Description Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Describe what happened',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Type here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Time and Place
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'When & Where',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimePickerTile(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildLocationPickerTile(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerTile(String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Time picker method
  Widget _buildTimePickerTile() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 20, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              selectedTimeText,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Location picker method
  Widget _buildLocationPickerTile() {
    return InkWell(
      onTap: () => _selectLocation(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 20, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedPlaceText,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Time selection method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reportController.selectedTime.value,
      helpText: 'Select Incident Time',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        reportController.selectedTime.value = picked;
        selectedTimeText = '${picked.hourOfPeriod}:${picked.minute.toString().padLeft(2, '0')} ${picked.period == DayPeriod.am ? 'AM' : 'PM'}';
      });
    }
  }

  // Location selection method - Interactive Map
  Future<void> _selectLocation(BuildContext context) async {
    // Show map selection dialog using Google Maps
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MapSelectionDialog(
          onLocationSelected: (LatLng location, String address) {
            setState(() {
              currentAddress = address;
              selectedPlaceText = address;
              reportController.selectedLocation.value = location;
              reportController.isLocationSelelcted(true);
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // Update methods
  void _updateTimeDisplay(TimeOfDay time) {
    setState(() {
      selectedTimeText = '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
    });
  }

  void _updateLocationDisplay(LatLng location) {
    setState(() {
      selectedPlaceText = currentAddress.isNotEmpty ? currentAddress : 'Location Selected';
    });
  }
}

// Map Selection Dialog Widget using Google Maps
class _MapSelectionDialog extends StatefulWidget {
  final Function(LatLng location, String address) onLocationSelected;

  const _MapSelectionDialog({required this.onLocationSelected});

  @override
  State<_MapSelectionDialog> createState() => _MapSelectionDialogState();
}

class _MapSelectionDialogState extends State<_MapSelectionDialog> {
  LatLng? selectedPosition;
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  String selectedAddress = 'Tap on the map to select location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Select Location', style: GoogleFonts.poppins()),
        actions: [
          if (selectedPosition != null)
            TextButton(
              onPressed: () => _confirmSelection(),
              child: Text(
                'Confirm',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Address display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Text(
              selectedAddress,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Map
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 13.0,
              ),
              onTap: _onMapTap,
              markers: selectedPosition != null ? {
                Marker(
                  markerId: MarkerId('selected'),
                  position: selectedPosition!,
                ),
              } : {},
            ),
          ),
          
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                const Icon(Icons.touch_app, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  'Tap on the map to select the incident location',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTap(LatLng point) async {
    setState(() {
      selectedPosition = point;
    });

    try {
      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        setState(() {
          selectedAddress = address;
        });
      } else {
        setState(() {
          selectedAddress = '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      setState(() {
        selectedAddress = '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
      });
    }
  }

  void _confirmSelection() async {
    if (selectedPosition != null) {
      widget.onLocationSelected(selectedPosition!, selectedAddress);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Get current location
      final location = location_pkg.Location();
      final currentLocation = await location.getLocation();
      
      setState(() {
        selectedPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
      
      // Move map to current location
      final controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedPosition!,
            zoom: 13.0,
          ),
        ),
      );
      
      // Update address for current location
      _onMapTap(selectedPosition!);
    } catch (e) {
      // If location fails, use a default location (e.g., center of world)
      setState(() {
        selectedPosition = LatLng(0, 0);
      });
    }
  }
}
