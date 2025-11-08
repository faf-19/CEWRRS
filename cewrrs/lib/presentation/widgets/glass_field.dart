import 'package:flutter/material.dart';
import '../themes/colors.dart';

class GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;

  const GlassField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.hint,
    this.suffixIcon,
    this.maxLength,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: TextInputType.phone,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon,
          prefix: prefixIcon,
          counterText: maxLength != null
              ? ''
              : null, // Hide character counter if maxLength is set

          filled: true,
          fillColor: const Color.fromARGB(255, 241, 240, 240).withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Appcolors.primary, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
