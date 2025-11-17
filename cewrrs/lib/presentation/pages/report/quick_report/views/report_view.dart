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
import 'package:cewrrs/presentation/widgets/phone_input_modal.dart';
import 'package:cewrrs/presentation/widgets/report_app_bar.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:latlong2/latlong.dart' as latlong;
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
  
  // Map related state
  final fm.MapController _mapController = fm.MapController();
  bool _isMapVisible = false;
  final latlong.LatLng _defaultLocation = const latlong.LatLng(8.9889820, 38.7703300); // Addis Ababa coordinates

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    // Listen for location changes to show/hide map
    reportController.isLocationSelelcted.listen((isSelected) {
      setState(() {
        _isMapVisible = isSelected;
      });
    });
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tab Bar with Enhanced Selection Effects
                        _buildTabBar(),
                        
                        const SizedBox(height: 12),

                        // Tab Content Area with Responsive Height
                        _buildTabContentArea(),

                        const SizedBox(height: 8),

                        // Map Preview (only shown when location is selected)
                        if (_isMapVisible) _buildMapPreview(),

                        const SizedBox(height: 8),

                        // Description Section
                        _buildDescriptionCard(),

                        const SizedBox(height: 8),

                        // Incident Section (Time & Location)
                        _buildIncidentCard(),

                        const SizedBox(height: 16),

                        // Submit Button
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
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
    return SizedBox(
      height: 60, // Fixed height for consistent sizing
      child: Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.blue.shade900
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
                    ? Colors.blue.shade900
                    : Colors.blue.shade400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContentArea() {
    return Container(
      height: 180, // Further increased height to prevent overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Flutter Map
            fm.FlutterMap(
              mapController: _mapController,
              options: fm.MapOptions(
                center: reportController.selectedLocation.value != null ? latlong.LatLng(reportController.selectedLocation.value!.latitude, reportController.selectedLocation.value!.longitude) : _defaultLocation,
                zoom: 15.0,
                onTap: (tapPosition, point) {}, // Disabled to prevent accidental taps
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.cewrrs.app',
                ),
                if (reportController.selectedLocation.value != null)
                  fm.MarkerLayer(
                    markers: [
                      fm.Marker(
                        point: latlong.LatLng(reportController.selectedLocation.value!.latitude, reportController.selectedLocation.value!.longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            // Location info overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedPlaceText,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_location, color: Colors.blue, size: 18),
                          onPressed: () => _selectLocation(context),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap the edit icon to change location',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
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
            Expanded(
              child: Text(
                selectedTimeText,
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
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _submitReport,
        icon: const Icon(Icons.send, size: 18),
        label: Text(
          'Submit',
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
          mapController: _mapController,
          onLocationSelected: (latlong.LatLng location, String address) {
            setState(() {
              currentAddress = address;
              selectedPlaceText = address;
              reportController.updateMarker(google_maps.LatLng(location.latitude, location.longitude));
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _submitReport() {
    // Show phone input modal for report submission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PhoneInputModal(
        onClose: () {
          // Return to report view after modal flow
          // Optionally navigate somewhere else after report is submitted
          Get.back();
        },
      ),
    );
  }
}

// Map Selection Dialog Widget using Flutter Map (Free Alternative)
class _MapSelectionDialog extends StatefulWidget {
  final fm.MapController mapController;
  final Function(latlong.LatLng location, String address) onLocationSelected;

  const _MapSelectionDialog({
    required this.mapController,
    required this.onLocationSelected,
  });

  @override
  State<_MapSelectionDialog> createState() => _MapSelectionDialogState();
}

class _MapSelectionDialogState extends State<_MapSelectionDialog> {
  latlong.LatLng? selectedPosition;
  final fm.MapController _mapController = fm.MapController();
  String selectedAddress = 'Tap on the map to select location';
  final latlong.LatLng _defaultLocation = const latlong.LatLng(8.9889820, 38.7703300); // Addis Ababa

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
            child: fm.FlutterMap(
              mapController: _mapController,
              options: fm.MapOptions(
                center: _defaultLocation,
                zoom: 13.0,
                onTap: (tapPosition, point) => _onMapTap(point),
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.cewrrs.app',
                ),
                if (selectedPosition != null)
                  fm.MarkerLayer(
                    markers: [
                      fm.Marker(
                        point: selectedPosition!,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
              ],
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

  void _onMapTap(latlong.LatLng point) async {
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
      // Check location permission
      final location = location_pkg.Location();
      
      // Request permission if not granted
      location_pkg.PermissionStatus permission = await location.hasPermission();
      if (permission == location_pkg.PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != location_pkg.PermissionStatus.granted) {
          // Use default location if permission denied
          setState(() {
            selectedPosition = _defaultLocation;
          });
          _onMapTap(_defaultLocation);
          return;
        }
      }
      
      // Get current location
      final currentLocation = await location.getLocation();
      
      setState(() {
        selectedPosition = latlong.LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
      
      // Move map to current location
      _mapController.move(
        selectedPosition!,
        13.0,
      );
      
      // Update address for current location
      _onMapTap(selectedPosition!);
    } catch (e) {
      // If location fails, use default location
      setState(() {
        selectedPosition = _defaultLocation;
      });
      _onMapTap(_defaultLocation);
    }
  }
}
