import 'package:cewrrs/presentation/controllers/sos_controller.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SosPage extends StatelessWidget {
  final SosController controller = Get.put(SosController());

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
//      appBar: CustomAppbar(controller: homeController),
      backgroundColor: Appcolors.background,
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final offices = controller.offices;
          if (offices.isEmpty) {
            return Center(child: Text('No emergency contacts available.'));
          }

          return ListView.separated(
            itemCount: offices.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final office = offices[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(Icons.location_on, color: Colors.redAccent),
                  title: Text(office.subcity, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(office.city),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 18, color: Colors.green),
                      SizedBox(height: 4),
                      Text(office.phone, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
