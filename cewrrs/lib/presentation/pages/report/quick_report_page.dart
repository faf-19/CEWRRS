// import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
// import 'package:cewrrs/presentation/themes/colors.dart';
// import 'package:cewrrs/presentation/themes/text_style.dart';
// import 'package:cewrrs/presentation/widgets/quick_report/attachment_upload_field.dart';
// import 'package:cewrrs/presentation/widgets/quick_report/fields.dart';
// import 'package:cewrrs/presentation/widgets/quick_report/thank_you.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class QuickReportPage extends GetView<ReportController> {
//   const QuickReportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_sharp,
//             color: Appcolors.textDark,
//           ),
//           onPressed: () => Get.offAllNamed('/intro'),
//         ),
//         title: Text(
//           "Quick Report",
//           style: AppTextStyles.heading.copyWith(
//             color: Appcolors.primary,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Image.asset('assets/images/logo.png', width: 32, height: 32),
//           ),
//         ],
//       ),
//       backgroundColor: Appcolors.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ──────── Region ────────
//               const Text(
//                 "Region/City",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               RegionDropdown(controller: controller),
//               const SizedBox(height: 16),

//               // ──────── Zone / Sub‑City (dynamic) ────────
//               Obx(() {
//                 final region = controller.selectedRegion.value;
//                 final bool isSpecial =
//                     region == "Addis Ababa" || region == "Dire Dawa";

//                 final String label = isSpecial
//                     ? "Select Sub‑City"
//                     : "Select Zone";

//                 final List<String> items = isSpecial
//                     ? controller.subCities[region] ?? []
//                     : controller.zones;

//                 final RxnString selected = isSpecial
//                     ? controller.selectedSubCity
//                     : controller.selectedZone;

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GenericDropdown(
//                       label: label,
//                       items: items,
//                       selected: selected,
//                       isRequired: true,
//                     ),
//                   ],
//                 );
//               }),
//               const SizedBox(height: 16),

//               // ──────── Woreda ────────
//               const Text(
//                 "Woreda",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               GenericDropdown(
//                 label: "Select Woreda",
//                 items: controller.woredas,
//                 selected: controller.selectedWoreda,
//                 isRequired: true,
//               ),
//               const SizedBox(height: 16),

//               // ──────── Kebele ────────
//               const Text(
//                 "Kebele",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               ReactiveTextField(
//                 label: "Enter Kebele",
//                 value: controller.kebele,
//                 isRequired: true,
//               ),
//               const SizedBox(height: 16),

//               // ──────── Attachment ────────
//               const Text(
//                 "Attachment",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               AttachmentUploadField(controller: controller),
//               const SizedBox(height: 16),

//               // ──────── Description ────────
//               const Text(
//                 "Description",
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               ReactiveTextField(
//                 label: "Enter a description",
//                 value: controller.description,
//                 maxLines: 5,
//                 isRequired: true,
//               ),
//               const SizedBox(height: 32),

//               // ──────── Submit ────────
//               Obx(() {
//                 final canSubmit = controller.isFormValid;
//                 return SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: canSubmit
//                         ? () async {
//                             final success = await controller
//                                 .validateAndSubmit();
//                             if (success) {
//                               showThankYouAndRedirect(context);
//                               controller.resetForm();
//                             }
//                           }
//                         : () {
//                             Get.snackbar(
//                               'Incomplete',
//                               'Please complete all required fields and attach a file (≤10 MB).',
//                               backgroundColor: Colors.red.shade600,
//                               colorText: Colors.white,
//                             );
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: canSubmit
//                           ? Appcolors.primary
//                           : Colors.grey.shade400,
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 3,
//                     ),
//                     child: Text(
//                       canSubmit ? "Submit Report" : "Complete Required Fields",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
