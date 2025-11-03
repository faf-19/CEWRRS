import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/data/models/report_model.dart';

class LocalStorageService {
  final _storage = GetStorage();

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
}
