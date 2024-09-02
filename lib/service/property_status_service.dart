import 'package:paradigm_mex/models/property.dart';

import 'database_service.dart';

class PropertyStatusService {
  late List<PropertyEnum> propertyStatuses = [];
  late final DatabaseService databaseService;

  PropertyStatusService() {
    this.databaseService = DatabaseService();
    getAllPropertyStatuses();
  }

  Future<List<PropertyEnum>> getAllPropertyStatuses() async {
    if (this.propertyStatuses.isEmpty) {
      this.propertyStatuses = await databaseService.getStatuses();
      return this.propertyStatuses;
    } else {
      return this.propertyStatuses;
    }
  }

  Future<PropertyEnum> getPropertyStatus(String statusId) async {
    List<PropertyEnum> allPropertyStatuses = await this.getAllPropertyStatuses();
    try {
      PropertyEnum status = allPropertyStatuses.firstWhere((status) =>
      status.name == statusId,
          orElse: () => null as PropertyEnum);
      return status;
    } on Error catch(err) {
      throw 'Error getting PropertyStatus \'${statusId}\': ${err}';
    }
  }
}
