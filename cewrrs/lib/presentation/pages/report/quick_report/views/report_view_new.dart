import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendphoto.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendvideo.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendaudio.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendfile.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendlink.dart';
import 'package:cewrrs/presentation/widgets/report_app_bar.dart';
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
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab Bar with Enhanced Selection Effects
              _buildTabBar(),
              
              const SizedBox(height: 16),

              // Tab Content Area with Fixed Height
              SizedBox(
                height: 180, // Compact height to prevent overflow
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SendPhotoWidget(reportController: reportController),
                    SendVideoWidget(reportController: reportController, isSignLanguage: widget.isSign),
                    SendaudioWidget(reportController: reportController),
                    SendFileWidget(reportController: reportController),
                    SendLinkWidget(reportController: reportController),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Description Section
              _buildDescriptionCard(),

              const SizedBox(height: 12),

              // Incident Section (Time & Location)
              _buildIncidentCard(),

              const SizedBox(height: 16),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: tabController,
        indicator: const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        onTap: (index) {
          setState(() {});
        },
        tabs: [
          _buildTab(0, Icons.camera, 'Camera'),
          _buildTab(1, Icons.videocam, 'Video'),
          _buildTab(2, Icons.mic, 'Audio'),
          _buildTab(3, Icons.attach_file, 'File'),
          _buildTab(4, Icons.link, 'URL'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    final isSelected = tabController.index == index;
    return Tab(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected 
                  ? Colors.blue.shade700 
                  : Colors.blue.shade400,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
    fontFamily: 'Montserrat',
    
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? Colors.blue.shade700 
                    : Colors.blue.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
    fontFamily: 'Montserrat',
    
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe what happened...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Incident',
                  style: TextStyle(
    fontFamily: 'Montserrat',
    
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTimePickerTile(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLocationPickerTile(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              selectedTimeText,
              style: TextStyle(
    fontFamily: 'Montserrat',
    
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPickerTile() {
    return InkWell(
      onTap: () => _selectLocation(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedPlaceText,
                style: TextStyle(
    fontFamily: 'Montserrat',
    
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _submitReport,
        icon: const Icon(Icons.send, size: 18),
        label: Text(
          'Submit Report',
          style: TextStyle(
    fontFamily: 'Montserrat',
    
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
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

  void _submitReport() {
    // Navigate to phone input for verification before submission
    Get.toNamed('/phone');
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
        title: Text('Select Location', style: TextStyle(
    fontFamily: 'Montserrat',
    )),
        actions: [
          if (selectedPosition != null)
            TextButton(
              onPressed: () => _confirmSelection(),
              child: Text(
                'Confirm',
                style: TextStyle(
    fontFamily: 'Montserrat',
    
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
              style: TextStyle(
    fontFamily: 'Montserrat',
    
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 13.0,
              ),
              onTap: _onMapTap,
              markers: selectedPosition != null ? {
                Marker(
                  markerId: const MarkerId('selected'),
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
                  style: TextStyle(
    fontFamily: 'Montserrat',
    
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
        selectedPosition = const LatLng(0, 0);
      });
    }
  }
}