// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SendLinkWidget extends StatefulWidget {
  final QuuickReportController reportController;
  const SendLinkWidget({super.key, required this.reportController});

  @override
  State<SendLinkWidget> createState() => _SendLinkWidgetState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _actionButton(
        icon: Icons.link,
        label: 'Add Links',
        onTap: () => _showLinkDialog(context),
        color: Colors.orange.shade50,
        iconColor: Colors.orange.shade700,
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
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: iconColor.withValues(alpha: .35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: .25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
    fontFamily: 'Montserrat',

                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade100.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.link, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to open',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.open_in_new, color: Colors.orange.shade700, size: 20),
            onPressed: () => _showLinkInPopup(link),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade400, size: 20),
            onPressed: () => deleteLink(widget.reportController.selectedLinks.indexOf(link)),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  void _showLinkDialog(BuildContext context) {
    String? errorText;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Text(
                    "Enter URL",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Add a web link to your report",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              content: TextFormField(
                cursorHeight: 20,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter URL',
                  labelStyle: TextStyle(color: Colors.orange.shade700),
                  prefixIcon: Icon(Icons.link, color: Colors.orange.shade700),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange.shade700, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange.shade700, width: 1.5),
                  ),
                  errorText: errorText,
                ),
                controller: _link,
                onChanged: (value) {
                  setState(() {
                    errorText = _validateUrl(value.trim());
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final String enteredLink = _link.text.trim();
    
                    if (enteredLink.isNotEmpty && _validateUrl(enteredLink) == null) {
                      String modifiedLink = enteredLink;
                      if (!enteredLink.startsWith('http://') && !enteredLink.startsWith('https://')) {
                        modifiedLink = 'https://$enteredLink';
                      }
    
                      this.setState(() {
                        widget.reportController.selectedLinks.add(modifiedLink);
                        _link.clear();
                      });
                      Get.snackbar("Success!", "Link added successfully");
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        errorText = _validateUrl(enteredLink) ?? 'Please enter a valid URL';
                      });
                    }
                  },
                  child: const Text(
                    'Add Link',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _validateUrl(String url) {
    if (url.isEmpty) {
      return 'URL cannot be empty';
    }

    // Basic URL validation regex
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(url)) {
      return 'Please enter a valid URL';
    }

    return null;
  }
}
