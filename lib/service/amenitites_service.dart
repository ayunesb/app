import 'package:paradigm_mex/models/property.dart';

import 'database_service.dart';

class AmenitiesService {
  late List<PropertyEnum> amenities = [];
  late final DatabaseService databaseService;

  AmenitiesService() {
    this.databaseService = DatabaseService();
    databaseService.getAmenities().then((value) => this.amenities = value);
  }

  Future<List<PropertyEnum>> getAllAmenities() async {
    if (this.amenities.isEmpty) {
      this.amenities = await databaseService.getAmenities();
      int index = this.amenities.indexWhere((element) => element.name == "any");
      PropertyEnum first = this.amenities.first;
      PropertyEnum any = this.amenities[index];
      this.amenities.first = any;
      this.amenities[index] = first;

      return this.amenities;
    }
    else {
      return this.amenities;
    }
  }

  Future<List<PropertyEnum>> filterPropertyAmenities(List<String> amenityIds) async {
    List<PropertyEnum> allAmenities = await this.getAllAmenities();
    List<PropertyEnum> filtered = allAmenities.where((amenity) {
      return (amenityIds.firstWhere((amenityId) => amenityId == amenity.name,
          orElse: () => "")).isNotEmpty;
    }).toList();
    return filtered;
  }
}
