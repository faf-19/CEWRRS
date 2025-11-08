import 'dart:io';

import 'package:e_carta_app/app/modules/report/controllers/report_controller.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/upload_dilaog.dart';
import 'package:e_carta_app/config/theme/app_colors.dart';
import 'package:e_carta_app/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class SendFileWidget extends StatefulWidget {
  final ReportController reportController;
  SendFileWidget({Key? key, required this.reportController});

  @override
  _SendLinkWidgetState createState() => _SendLinkWidgetState();
}

class _SendLinkWidgetState extends State<SendFileWidget> {
  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void deleteFile(int index) {
    setState(() {
      widget.reportController.selectedFile.removeAt(index);
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
                    'File Upload'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Appcolors.primary,
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(height: 0.5, color: Colors.grey),
                  widget.reportController.selectedFile.isNotEmpty
                      ? SizedBox(
                          height: 70,
                          child: ListView.builder(
                            itemCount:
                                widget.reportController.selectedFile.length,
                            itemBuilder: (BuildContext context, int index) {
                              final file =
                                  widget.reportController.selectedFile[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () => _openFile(file),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          file.name,
                                        ), // Display the file name
                                      ),
                                      GestureDetector(
                                        onTap: () => deleteFile(index),
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
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: 5),
                  widget.reportController.selectedFile.length < 5
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UploadDialog(
                                      onUpload: uploadfile,
                                      title: 'Upload Files'.tr,
                                      contentTexts: [
                                        'You can upload 5  files'.tr,
                                        'Maximum upload size: 20 MB.'.tr,
                                      ],
                                    );
                                  },
                                );
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
                                      'Insert File'.tr,
                                      style: AppTextStyles.bodySmall.copyWith(
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
                  SizedBox(height: 10),
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

  void uploadfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      // Validate the file extension
      if (file.extension == 'pdf' ||
          file.extension == 'doc' ||
          file.extension == 'docx') {
        // Get the file size
        var fileSize = await File(file.path!).length();
        double fileSizeInMegabytes = fileSize / (1024 * 1024);

        // Validate the file size
        if (fileSizeInMegabytes <= 20) {
          // File is valid and within the size limit, proceed with processing
          // Add your custom file processing logic here
          setState(() {
            widget.reportController.selectedFile.add(file);
          });
        } else {
          Get.snackbar(
            "File Too Large!!",
            "Please select a file smaller than 20 MB".tr,
          );
          // File is too large
        }
      } else {
        Get.snackbar("Invalid File!!".tr, "Please select a PDF or DOC file".tr);
        // Invalid file type
      }
    } else {
      // User canceled the file picking
    }
  }
}
