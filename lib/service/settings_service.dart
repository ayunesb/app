import 'package:paradigm_mex/models/property.dart';

import '../models/settings.dart';
import 'database_service.dart';

class SettingsService {
  late List<AppSettings> settings = [];
  late final DatabaseService databaseService;

  SettingsService() {
    this.databaseService = DatabaseService();
    databaseService.getSettings().then((value) => this.settings = value);
  }

  Future<List<AppSettings>> getAllSettings() async {
    if (this.settings.isEmpty) {
      this.settings = await databaseService.getSettings();
      return this.settings;
    }
    else {
      return this.settings;
    }
  }


  Future<bool> updateSettings(List<AppSettings> settings) async {
    return await databaseService.updateSetting(settings: settings);
  }
}
