import 'package:e_carta_app/app/modules/report/controllers/report_controller.dart';
import 'package:e_carta_app/app/modules/report/views/report_list_view.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/mapview.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/sendaudio.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/sendfile.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/sendlink.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/sendphoto.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/sendvideo.dart';
import 'package:e_carta_app/config/constant/app_button.dart';
import 'package:e_carta_app/config/theme/app_colors.dart';
import 'package:e_carta_app/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ReportView extends StatefulWidget {
  final int initialTabIndex;
  final bool isSign;
  const ReportView({super.key, this.initialTabIndex = 0, required this.isSign});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late ReportController controller = ReportController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportController());
    controller.tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        title: Text(
          'Report',
          style: AppTextStyles.headline3.copyWith(color: Appcolors.background),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: Appcolors.background),
            onPressed: () {
              Get.to(() => ReportsListView());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isSendreport.value == true) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              // Fixed Tab Bar Section
              Obx(
                () => controller.showAll.value
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: buildTabbar(),
                      )
                    : const SizedBox(),
              ),
              // Scrollable Content Section
              Expanded(
                child: Column(
                  children: [
                    // Tab Content with Flexible height
                    Flexible(child: buildTabBarView()),
                    // Description and Incident Details
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: 80,
                        ), // Space for submit button
                        child: Column(
                          children: [
                            buildFirstCard(),
                            // Contact Me Section
                            // buildSecondCard(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Appcolors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 3,
                              ),
                              onPressed: () {
                                controller.submitReport();
                              },
                              child: Text(
                                "Submit",
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Fixed Submit Button at Bottom

              // Fixed Submit Button at Bottom
            ],
          );
        }
      }),
    );
  }

  buildTabbar() {
    return TabBar(
      controller: controller.tabController,
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        color: Colors.white,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 0.5),
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
      unselectedLabelColor: Colors.white,
      tabs: [
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: controller.tabIndex == 0
                  ? Appcolors.primary
                  : Colors.grey.shade400,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(Iconsax.camera),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: controller.tabIndex == 1
                  ? Appcolors.primary
                  : Colors.grey.shade400,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(Iconsax.video),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: controller.tabIndex == 2
                  ? Appcolors.primary
                  : Colors.grey.shade400,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(Iconsax.voice_cricle),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: controller.tabIndex == 3
                  ? Appcolors.primary
                  : Colors.grey.shade400,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(Iconsax.document),
            ),
          ),
        ),
      ],
      onTap: (index) {
        setState(() {
          controller.changeTabIndex(index);
          controller.tabController.animateTo(index);
        });
      },
    );
  }

  buildTabBarView() {
    return SizedBox(
      height: 150,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: [
          SendPhotoWidget(reportController: controller),
          SendVideoWidget(
            reportController: controller,
            isSignLangauge: widget.isSign,
          ),
          SendaudioWidget(reportController: controller),
          // SendLinkWidget(
          //   reportController: controller,
          // ),
          SendFileWidget(reportController: controller),
        ],
      ),
    );
  }

  buildFirstCard() {
    return Column(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: controller.descriptionformKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: controller.description,
                  maxLines: 5,
                  hint: "Description".tr,
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Time and place'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Appcolors.primary,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 8.0), // Adjust the height as needed
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: buildIncidentTime()),
                      SizedBox(width: 1),
                      Expanded(child: buildIncidentPlace()),
                    ],
                  ),
                ),
                SizedBox(height: 8.0), // Adjust the height as needed
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildIncidentTime() {
    return Obx(
      () => !controller.isDateSelelcted.value
          ? GestureDetector(
              onTap: () {
                selelctTime();
              },
              child: Row(
                children: [
                  const Icon(Iconsax.clock, color: Appcolors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Time'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Appcolors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : showSelelctedTime(),
    );
  }

  buildIncidentPlace() {
    return Obx(
      () => !controller.isLocationSelelcted.value
          ? GestureDetector(
              onTap: () {
                Get.to(() => MapView());
              },
              child: Row(
                children: [
                  const Icon(Iconsax.location, color: Appcolors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Place'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Appcolors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : showSelelctedPlace(),
    );
  }

  showSelelctedTime() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time selected:'.tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: Appcolors.primary,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Iconsax.clock, color: Appcolors.primary, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        AppButton(
          borderRadius: 8.0,
          paddingHorizontal: 12,
          paddingVertical: 8,
          text: 'Change'.tr,
          onPressed: () {
            selelctTime();
          },
          buttonColor: Appcolors.primary,
          textColor: Appcolors.secondary,
        ),
      ],
    );
  }

  showSelelctedPlace() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Place selected:'.tr,
              style: AppTextStyles.bodySmall.copyWith(
                color: Appcolors.primary,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Iconsax.location, color: Appcolors.primary, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        AppButton(
          borderRadius: 8.0,
          paddingHorizontal: 12,
          paddingVertical: 8,
          text: 'Change'.tr,
          onPressed: () {
            Get.to(() => MapView());
          },
          buttonColor: Appcolors.primary,
          textColor: Appcolors.secondary,
        ),
      ],
    );
  }

  void selelctTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Appcolors.primary,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(
              primary: Appcolors.primary,
            ).copyWith(secondary: Appcolors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Appcolors.primary,
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              colorScheme: ColorScheme.light(
                primary: Appcolors.primary,
              ).copyWith(secondary: Appcolors.primary),
            ),
            child: child!,
          );
        },
      );
      if (selectedTime != null) {
        final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        controller.selectedDateTime.value = selectedDateTime;
        controller.isDateSelelcted(true);
      } else {
        controller.isDateSelelcted(false);
      }
    }
  }
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final int? maxLength;
  final bool isPasswordField;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextInputAction textInputAction;
  final AutovalidateMode autoValidateMode;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppTextField({
    Key? key,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.isPasswordField = false,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.enable,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscureText = true;

  _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    wordCount = _getWordCount(widget.controller.text);
  }

  int _getWordCount(String text) {
    List<String> words = text.trim().split(' ');
    words.removeWhere((word) => word.isEmpty);
    return words.length.clamp(0, 20); // Set maximum word count to 20
  }

  void _updateWordCount(String newText) {
    setState(() {
      wordCount = _getWordCount(newText);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(newText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enable,
      obscureText: widget.isPasswordField ? obscureText : false,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Appcolors.primary,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      validator: widget.validator,
      onChanged: _updateWordCount,
      controller: widget.controller,
      autovalidateMode: widget.autoValidateMode,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Appcolors.primary.withValues(alpha: 0.5),
          fontSize: 12,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Appcolors.primary,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
        //counterText: widget.maxLines != 1 ? '$wordCount / 20' : '',
        fillColor: Appcolors.container,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    );
  }
}
