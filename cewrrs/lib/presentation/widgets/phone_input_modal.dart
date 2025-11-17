import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/text_style.dart';
import 'otp_modal.dart';
import 'thank_you_modal.dart';

class PhoneInputModal extends StatefulWidget {
  final VoidCallback? onClose;

  const PhoneInputModal({
    super.key,
    this.onClose,
  });

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
    // Format the 9-digit number with Ethiopian country code
    if (phone.length == 9) {
      return '+251 ${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return '+251 $phone';
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digits = value.replaceAll(RegExp(r'\D'), '');

    // Ethiopian phone numbers are 9 digits after +251
    if (digits.length != 9) {
      return 'Please enter a valid 9-digit Ethiopian phone number';
    }

    // Ethiopian mobile numbers typically start with 9, 7, or 8
    if (!RegExp(r'^[789]').hasMatch(digits)) {
      return 'Please enter a valid Ethiopian mobile number';
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
              'Please enter your Ethiopian phone number to receive a verification code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Montserrat',
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
                maxLength: 9,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '912345678',
                  prefixText: '+251 ',
                  prefixStyle: const TextStyle(
                    color: Appcolors.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  prefixIcon: const Icon(Icons.phone, color: Appcolors.primary),
                  counterText: '',
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
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  hintStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                  ),
                ),
                validator: _validatePhoneNumber,
                onFieldSubmitted: (_) => _submitPhoneNumber(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send Verification Code',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}