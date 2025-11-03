import 'package:flutter/material.dart';

class ReportPageConstants {
  // Titles
  static const reportTitle = "Incident Report";
  static const reportSuccessMessage = "✅ Report Saved";
  static const reportSuccessSubtitle = "Your incident report was stored locally.";

  // Step labels
  static const reportSteps = ["Location", "Time", "Details"];

  // Validation messages
  static const reportValidationError = "Please complete all fields in this step";
  static const reportMissingTitle = "Missing Info";

  // Field hints
  static const severityHint = "High / Medium / Low";

  // Storage keys
  static const reportStoragePrefix = "report_";

  // Button labels
  static const reportNext = "Next";
  static const reportBack = "Back";
  static const reportSubmit = "Submit";
}
