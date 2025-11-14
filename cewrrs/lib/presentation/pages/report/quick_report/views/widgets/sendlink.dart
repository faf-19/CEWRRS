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
  final _link = TextEditingController();

  @override
  void dispose() {
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action button for adding links
          _actionButton(
            icon: Icons.link,
            label: 'Add URL Links'.tr,
            onTap: () => _showLinkDialog(context),
            color: Colors.blue.shade50,
            iconColor: Colors.blue.shade700,
          ),
          
          const SizedBox(height: 16),
          
          // Links preview list - Reduced height
          if (widget.reportController.selectedLinks.isNotEmpty)
            Container(
              height: 120, // Reduced height
              child: ListView.builder(
                itemCount: widget.reportController.selectedLinks.length,
                itemBuilder: (context, index) {
                  final link = widget.reportController.selectedLinks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.link, color: Colors.blue),
                      title: Text(
                        link,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 16),
                        onPressed: () => deleteLink(index),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60, // Reduced height
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24), // Reduced icon size
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: iconColor,
                fontSize: 11, // Reduced font size
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
