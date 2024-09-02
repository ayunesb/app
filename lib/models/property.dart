import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paradigm_mex/models/image.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  @JsonKey(ignore: true)
  String id;
  String creatorId;
  String groupId;
  String propertyName;
  String streetAddress;
  String houseNumber;
  String colonia;
  String village;
  String postalCode;
  String province;
  String country;
  @JsonKey(fromJson: _GeoPointFromJson, toJson: _GeoPointToJson)
  GeoPoint? location;
  double currentPrice;
  double regularPrice;
  double currentPriceUSD;
  double regularPriceUSD;
  double previousPrice;
  String enDescription;
  String esDescription;
  String enNeighborhoodDescription;
  String esNeighborhoodDescription;
  String neighborhoodLink;
  String enLegalDocuments;
  String esLegalDocuments;
  int bedrooms;
  double bathrooms;
  double meters;
  String type;
  String dbStatus;
  int yearBuilt;
  bool? promoted;
  List<String>? amenitiesIds;
  String statusId;
  @JsonKey(fromJson: _DatetimeFromJson, toJson: _DatetimeToJson)
  DateTime? createdAt;
  @JsonKey(fromJson: _DatetimeFromJson, toJson: _DatetimeToJson)
  DateTime? updatedAt;
  bool deleted;
  @JsonKey(ignore: true)
  PropertyImageList? propertyImages;
  @JsonKey(ignore: true)
  bool favorite;
  @JsonKey(ignore: true)
  List<PropertyEnum> amenities = [];
  @JsonKey(ignore: true)
  PropertyEnum? status;

  Property({
    this.id = "",
    this.creatorId = "",
    this.groupId = "",
    this.propertyName = "",
    this.streetAddress = "",
    this.houseNumber = "",
    this.colonia = "",
    this.village = "",
    this.postalCode = "",
    this.province = "",
    this.country = "",
    this.location,
    this.currentPrice = 0.0,
    this.regularPrice = 0.0,
    this.currentPriceUSD = 0.0,
    this.regularPriceUSD = 0.0,
    this.enDescription = "",
    this.previousPrice = 0.0,
    this.esDescription = "",
    this.enNeighborhoodDescription = "",
    this.esNeighborhoodDescription = "",
    this.neighborhoodLink = "",
    this.enLegalDocuments = "",
    this.esLegalDocuments = "",
    this.bedrooms = 0,
    this.bathrooms = 0.0,
    this.meters = 0.0,
    this.type = "",
    this.dbStatus = "active",
    this.yearBuilt = 0,
    this.promoted = false,
    this.amenitiesIds,
    this.statusId = "",
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
    this.propertyImages,
    this.favorite = false,
    this.status,
  }) {
    this.createdAt = this.createdAt ?? DateTime.now();
    this.updatedAt = this.createdAt ?? DateTime.now();
    this.amenitiesIds = this.amenitiesIds ?? [];
    this.location = this.location ?? GeoPoint(0.0, 0.0);
    this.propertyImages = PropertyImageList([]);
  }

  String get fullAddress {
    String fullAddress = '';
    fullAddress +=
        this.propertyName.isNotEmpty ? (this.propertyName + ', ') : '';
    fullAddress += this.houseNumber.isNotEmpty ? (this.houseNumber + ' ') : '';
    fullAddress +=
        this.streetAddress.isNotEmpty ? (this.streetAddress + ', ') : '';
    fullAddress += this.village.isNotEmpty ? (this.village + ', ') : '';
    fullAddress += this.colonia.isNotEmpty ? (this.colonia + ', ') : '';
    fullAddress += this.province.isNotEmpty ? (this.province + ', ') : '';
    fullAddress += this.country;
    return fullAddress;
  }

  static DateTime? _DatetimeFromJson(Timestamp timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  static Timestamp _DatetimeToJson(DateTime? time) =>
      Timestamp.fromMillisecondsSinceEpoch(time!.millisecondsSinceEpoch);

  static GeoPoint? _GeoPointFromJson(GeoPoint? geoPoint) => geoPoint;
  static GeoPoint _GeoPointToJson(GeoPoint? geoPoint) {
    geoPoint = geoPoint ?? GeoPoint(0.0, 0.0);
    return geoPoint;
    //return {"latitude": geoPoint.latitude, "longitude": geoPoint.longitude};
  }

  factory Property.fromJson(String id, Map<String, dynamic> json) {
    var property = _$PropertyFromJson(json);
    property.id = id;
    return property;
  }
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

class PropertyList {
  late List<Property> list = [];
  PropertyList({required this.list});

  factory PropertyList.fromSnapshot(QuerySnapshot<Map<String, dynamic>> s) {
    List<Property> list = s.docs.map<Property>((ds) {
      return Property.fromJson(ds.id, ds.data());
    }).toList();
    return PropertyList(list: list);
  }

  PropertyList filterProperties(List<bool> bedroomsSelections) {
    int numberOfBedrooms = 4;
    final index = bedroomsSelections.indexWhere((element) => element == true);
    // list is 0 based
    numberOfBedrooms = index + 1;
    if (numberOfBedrooms > 3) {
      // show all
      return this;
    }

    this.list = this
        .list
        .where((property) => property.bedrooms <= numberOfBedrooms)
        .toList();
    return this;
  }
/*
  print(1.compareTo(2)); // => -1
  print(2.compareTo(1)); // => 1
  print(1.compareTo(1)); // => 0
 */
  PropertyList sortByCurrentPrice(bool ascending) {
    this.list.sort((left, right) {
      if (left.favorite && !right.favorite) {
        return -1;
      }
      else if (!left.favorite && right.favorite) {
        return 1;
      }
      else {
        // both are either favorite or not
        if (ascending) {
          return left.currentPrice.compareTo(right.currentPrice);
        } else {
          return right.currentPrice.compareTo(left.currentPrice);
        }
      }
    });
    return this;
  }
}

@JsonSerializable()
class PropertyEnum {
  String name;
  String enLabel;
  String esLabel;
  @JsonKey(
      fromJson: _PropertyEnumDatetimeFromJson,
      toJson: _PropertyEnumDatetimeToJson)
  DateTime? createdAt;
  @JsonKey(
      fromJson: _PropertyEnumDatetimeFromJson,
      toJson: _PropertyEnumDatetimeToJson)
  DateTime? updatedAt;
  PropertyEnum({
    this.name = "",
    this.enLabel = "",
    this.esLabel = "",
    this.createdAt,
    this.updatedAt,
  }) {
    this.createdAt = this.createdAt ?? DateTime.now();
    this.updatedAt = this.createdAt ?? DateTime.now();
  }

  static DateTime? _PropertyEnumDatetimeFromJson(Timestamp timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  static Timestamp _PropertyEnumDatetimeToJson(DateTime? time) =>
      Timestamp.fromMillisecondsSinceEpoch(time!.millisecondsSinceEpoch);

  factory PropertyEnum.fromJson(Map<String, dynamic> json) {
    PropertyEnum propertyEnum = _$PropertyEnumFromJson(json);
    return propertyEnum;
  }
  Map<String, dynamic> toJson() => _$PropertyEnumToJson(this);
}
