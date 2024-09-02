// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      creatorId: json['creatorId'] as String? ?? "",
      groupId: json['groupId'] as String? ?? "",
      propertyName: json['propertyName'] as String? ?? "",
      streetAddress: json['streetAddress'] as String? ?? "",
      houseNumber: json['houseNumber'] as String? ?? "",
      colonia: json['colonia'] as String? ?? "",
      village: json['village'] as String? ?? "",
      postalCode: json['postalCode'] as String? ?? "",
      province: json['province'] as String? ?? "",
      country: json['country'] as String? ?? "",
      location: Property._GeoPointFromJson(json['location'] as GeoPoint?),
      currentPrice: (json['currentPrice'] as num?)?.toDouble() ?? 0.0,
      regularPrice: (json['regularPrice'] as num?)?.toDouble() ?? 0.0,
      currentPriceUSD: (json['currentPriceUSD'] as num?)?.toDouble() ?? 0.0,
      regularPriceUSD: (json['regularPriceUSD'] as num?)?.toDouble() ?? 0.0,
      enDescription: json['enDescription'] as String? ?? "",
      previousPrice: (json['previousPrice'] as num?)?.toDouble() ?? 0.0,
      esDescription: json['esDescription'] as String? ?? "",
      enNeighborhoodDescription:
          json['enNeighborhoodDescription'] as String? ?? "",
      esNeighborhoodDescription:
          json['esNeighborhoodDescription'] as String? ?? "",
      neighborhoodLink: json['neighborhoodLink'] as String? ?? "",
      enLegalDocuments: json['enLegalDocuments'] as String? ?? "",
      esLegalDocuments: json['esLegalDocuments'] as String? ?? "",
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toDouble() ?? 0.0,
      meters: (json['meters'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String? ?? "",
      dbStatus: json['dbStatus'] as String? ?? "active",
      yearBuilt: json['yearBuilt'] as int? ?? 0,
      promoted: json['promoted'] as bool? ?? false,
      amenitiesIds: (json['amenitiesIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      statusId: json['statusId'] as String? ?? "",
      createdAt: Property._DatetimeFromJson(json['createdAt'] as Timestamp),
      updatedAt: Property._DatetimeFromJson(json['updatedAt'] as Timestamp),
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'creatorId': instance.creatorId,
      'groupId': instance.groupId,
      'propertyName': instance.propertyName,
      'streetAddress': instance.streetAddress,
      'houseNumber': instance.houseNumber,
      'colonia': instance.colonia,
      'village': instance.village,
      'postalCode': instance.postalCode,
      'province': instance.province,
      'country': instance.country,
      'location': Property._GeoPointToJson(instance.location),
      'currentPrice': instance.currentPrice,
      'regularPrice': instance.regularPrice,
      'currentPriceUSD': instance.currentPriceUSD,
      'regularPriceUSD': instance.regularPriceUSD,
      'previousPrice': instance.previousPrice,
      'enDescription': instance.enDescription,
      'esDescription': instance.esDescription,
      'enNeighborhoodDescription': instance.enNeighborhoodDescription,
      'esNeighborhoodDescription': instance.esNeighborhoodDescription,
      'neighborhoodLink': instance.neighborhoodLink,
      'enLegalDocuments': instance.enLegalDocuments,
      'esLegalDocuments': instance.esLegalDocuments,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'meters': instance.meters,
      'type': instance.type,
      'dbStatus': instance.dbStatus,
      'yearBuilt': instance.yearBuilt,
      'promoted': instance.promoted,
      'amenitiesIds': instance.amenitiesIds,
      'statusId': instance.statusId,
      'createdAt': Property._DatetimeToJson(instance.createdAt),
      'updatedAt': Property._DatetimeToJson(instance.updatedAt),
      'deleted': instance.deleted,
    };

PropertyEnum _$PropertyEnumFromJson(Map<String, dynamic> json) => PropertyEnum(
      name: json['name'] as String? ?? "",
      enLabel: json['enLabel'] as String? ?? "",
      esLabel: json['esLabel'] as String? ?? "",
      createdAt: PropertyEnum._PropertyEnumDatetimeFromJson(
          json['createdAt'] as Timestamp),
      updatedAt: PropertyEnum._PropertyEnumDatetimeFromJson(
          json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$PropertyEnumToJson(PropertyEnum instance) =>
    <String, dynamic>{
      'name': instance.name,
      'enLabel': instance.enLabel,
      'esLabel': instance.esLabel,
      'createdAt': PropertyEnum._PropertyEnumDatetimeToJson(instance.createdAt),
      'updatedAt': PropertyEnum._PropertyEnumDatetimeToJson(instance.updatedAt),
    };
