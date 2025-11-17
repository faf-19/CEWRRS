import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/data/models/report_model.dart';
import '../utils/security/otp_generator.dart';

/// Enhanced LocalStorageService with OTP management
/// This provides secure storage for sensitive data like OTP codes
class LocalStorageService {
  final _storage = GetStorage();
  static const String _otpKey = 'current_otp';

  // Report storage methods
  void saveReport(ReportModel report) {
    final key = 'report_${DateTime.now().millisecondsSinceEpoch}';
    _storage.write(key, report.toJson());
  }

  List<ReportModel> getAllReports() {
    final keys = _storage.getKeys().where((k) => k.startsWith('report_'));
    return keys.map((key) {
      final json = _storage.read(key);
      return ReportModel.fromJson(json);
    }).toList();
  }

  void clearReports() {
    final keys = _storage.getKeys().where((k) => k.startsWith('report_'));
    for (final key in keys) {
      _storage.remove(key);
    }
  }

  // OTP storage methods
  void saveOtp(OtpData otpData) {
    final otpJson = {
      'code': otpData.code,
      'expiryTime': otpData.expiryTime.toIso8601String(),
      'attempts': otpData.attempts,
      'isUsed': otpData.isUsed,
    };
    _storage.write(_otpKey, otpJson);
  }

  OtpData? getStoredOtp() {
    final otpJson = _storage.read(_otpKey);
    if (otpJson == null) return null;

    try {
      return OtpData(
        code: otpJson['code'] ?? '',
        expiryTime: DateTime.parse(otpJson['expiryTime'] ?? ''),
        attempts: otpJson['attempts'] ?? 0,
        isUsed: otpJson['isUsed'] ?? false,
      );
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
  }

  void removeOtp() {
    _storage.remove(_otpKey);
  }

  // Generic storage methods for other data
  void saveData(String key, dynamic data) {
    _storage.write(key, data);
  }

  T? getData<T>(String key) {
    return _storage.read<T>(key);
  }

  void removeData(String key) {
    _storage.remove(key);
  }

  void clearAll() {
    _storage.erase();
  }

  // Check if key exists
  bool hasKey(String key) {
    return _storage.hasData(key);
  }
}
