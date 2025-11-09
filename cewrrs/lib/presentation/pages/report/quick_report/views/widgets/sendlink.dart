// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SendLinkWidget extends StatefulWidget {
  final QuuickReportController reportController;
  SendLinkWidget({Key? key, required this.reportController});

  @override
  _SendLinkWidgetState createState() => _SendLinkWidgetState();
}

class _SendLinkWidgetState extends State<SendLinkWidget> {
  TextEditingController textEditingController = TextEditingController();
  final _link = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    _link.dispose();
    super.dispose();
  }

  void _showLinkInPopup(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void deleteLink(int index) {
    setState(() {
      widget.reportController.selectedLinks.removeAt(index);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Link Upload'.tr,
                    style: AppTextStyles.button.copyWith(
                      color: Appcolors.primary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Container(height: 0.5, color: Colors.grey),
                  widget.reportController.selectedLinks.isNotEmpty
                      ? SizedBox(
                          height: 10,
                          child: ListView.separated(
                            itemCount:
                                widget.reportController.selectedLinks.length,
                            itemBuilder: (BuildContext context, int index) {
                              final link =
                                  widget.reportController.selectedLinks[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () => _showLinkInPopup(link),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.link,
                                        color: Appcolors.primary,
                                      ),
                                      SizedBox(width: 2),
                                      Expanded(child: Text(link)),
                                      GestureDetector(
                                        onTap: () => deleteLink(index),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return const Divider(
                                    color: Appcolors.border,
                                  );
                                },
                          ),
                        )
                      : SizedBox(height: 6),
                  SizedBox(height: 2),
                  widget.reportController.selectedLinks.length < 5
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                _showLinkDialog(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                        0,
                                        3,
                                      ), // changes the position of the shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.file_copy,
                                      color: Appcolors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Add link'.tr,
                                      style: AppTextStyles.button.copyWith(
                                        color: Appcolors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(height: 7),
                  Container(height: 0.5, color: Colors.grey),
                ],
              ),
            ),
          ),

          //Description
        ],
      ),
    );
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                Text(
                  "Enter URL".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "You can upload 5 Links".tr,
                  style: AppTextStyles.button.copyWith(
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes the position of the shadow
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              cursorHeight: 20,
              autofocus: false,
              decoration: InputDecoration(
                labelText: 'Type URL'.tr,
                labelStyle: TextStyle(color: Appcolors.primary),
                prefixIcon: Icon(Icons.link, color: Appcolors.primary),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Appcolors.primary, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  gapPadding: 0.0,
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Appcolors.primary, width: 1.5),
                ),
              ),
              controller: _link,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
              ),
              onPressed: () {
                final String enteredLink = _link.text.trim();

                if (enteredLink.isNotEmpty) {
                  // Regular expression pattern to match a valid URL with a supported suffix

                  String modifiedLink = enteredLink;
                  if (!enteredLink.startsWith('https://')) {
                    modifiedLink = 'https://$enteredLink';
                  }

                  setState(() {
                    widget.reportController.selectedLinks.add(modifiedLink);
                    _link.clear();
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Add'.tr,
                style: AppTextStyles.button.copyWith(
                  color: Appcolors.border,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel'.tr,
                style: AppTextStyles.button.copyWith(
                  color: Appcolors.border,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
