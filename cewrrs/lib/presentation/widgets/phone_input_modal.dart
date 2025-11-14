import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/colors.dart';
import '../themes/text_style.dart';
import 'otp_modal.dart';
import 'thank_you_modal.dart';

class PhoneInputModal extends StatefulWidget {
  final VoidCallback? onClose;
  
  const PhoneInputModal({
    Key? key,
    this.onClose,
  }) : super(key: key);

  @override
  State<PhoneInputModal> createState() => _PhoneInputModalState();
}

class _PhoneInputModalState extends State<PhoneInputModal> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitPhoneNumber() {
    if (_formKey.currentState!.validate()) {
      // Close phone input modal and show OTP modal
      Navigator.of(context).pop();
      
      Future.delayed(const Duration(milliseconds: 100), () {
        _showOtpModal();
      });
    }
  }

  void _showOtpModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OtpModal(
        phoneNumber: _formatPhoneNumber(_phoneController.text),
        onVerify: (otp) {
          // Close OTP modal and show thank you modal
          Navigator.of(context).pop();
          
          Future.delayed(const Duration(milliseconds: 100), () {
            _showThankYouModal();
          });
        },
      ),
    );
  }

  void _showThankYouModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ThankYouModal(
        onClose: () {
          widget.onClose?.call();
        },
      ),
    );
  }

  String _formatPhoneNumber(String phone) {
    // Simple formatting for display
    if (phone.length >= 10) {
      return '+251 ${phone.substring(phone.length - 9, phone.length - 6)} ${phone.substring(phone.length - 6, phone.length - 3)} ${phone.substring(phone.length - 3)}';
    }
    return phone;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters for validation
    final digits = value.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length < 10) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Appcolors.primary,
                  radius: 20,
                  child: const Icon(Icons.phone, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Phone Verification',
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            const Text(
              'Please enter your phone number to receive a verification code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Phone Input Form
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+251912345678',
                  prefixIcon: const Icon(Icons.phone, color: Appcolors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Appcolors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: _validatePhoneNumber,
                onFieldSubmitted: (_) => _submitPhoneNumber(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Send Verification Code',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onClose?.call();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}