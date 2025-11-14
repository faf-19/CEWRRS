import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Montserrat Font Family Configuration
  static const String fontFamily = 'Montserrat';

  // Heading Styles
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: fontFamily,
  );

  static const TextStyle appTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    fontFamily: fontFamily,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Appcolors.primary,
    fontFamily: fontFamily,
  );

  // Additional Montserrat Styles
  static const TextStyle light = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.white70,
    fontFamily: fontFamily,
  );
  
  static const TextStyle medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle semiBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
    fontFamily: fontFamily,
  );

  static const TextStyle hint = TextStyle(
    color: Colors.white70,
    fontFamily: fontFamily,
  );
  
  static const TextStyle white = TextStyle(
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle link = TextStyle(
    color: Colors.lightBlueAccent,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );
}
