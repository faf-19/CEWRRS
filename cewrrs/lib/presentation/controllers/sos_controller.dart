import 'package:get/get.dart';

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

class SosController extends GetxController {
  var offices = <Office>[].obs;
  var selectedCity = ''.obs;
  var selectedSubcity = ''.obs;

  List<String> get cities => offices.map((e) => e.city).toSet().toList();

  List<String> get subcities => offices
      .where((e) => e.city == selectedCity.value)
      .map((e) => e.subcity)
      .toSet()
      .toList();

  Office? get selectedOffice => offices.firstWhereOrNull(
    (e) => e.city == selectedCity.value && e.subcity == selectedSubcity.value,
  );

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
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
}
