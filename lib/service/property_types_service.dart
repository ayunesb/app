import 'package:paradigm_mex/models/property.dart';

import 'database_service.dart';

class PropertyTypesService {
  late List<PropertyEnum> propertyTypes = [];
  late final DatabaseService databaseService;

  PropertyTypesService() {
    this.databaseService = DatabaseService();
  }

  Future<List<PropertyEnum>> getAllPropertyTypes() async {
    if (this.propertyTypes.isEmpty) {
      this.propertyTypes = await databaseService.getTypes();
      int index = this.propertyTypes.indexWhere((element) => element.name == "any");
      PropertyEnum first = this.propertyTypes.first;
      PropertyEnum any = this.propertyTypes[index];
      this.propertyTypes.first = any;
      this.propertyTypes[index] = first;
      return this.propertyTypes;
    } else {
      return this.propertyTypes;
    }
  }

  Future<PropertyEnum> getPropertyType(String typeId) async {
    List<PropertyEnum> allPropertyStatuses = await this.getAllPropertyTypes();

    PropertyEnum type = allPropertyStatuses.firstWhere((type) =>type.name == typeId,
        orElse: () => null as PropertyEnum);
    return type;
  }
}
