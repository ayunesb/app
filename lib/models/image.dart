import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class PropertyImage {
  String id;
  String? localPath;
  String? filePath;
  String? url;
  String? propertyId;
  int? order;
  bool? isDefault;

  PropertyImage({
    this.id = "",
    this.localPath,
    this.filePath,
    this.url,
    this.propertyId,
    this.order,
    this.isDefault,
  });

  factory PropertyImage.fromRef(Reference ref) {
    final String fullPath = ref.fullPath;
    final List<String> pathParts = fullPath.split("/");
    final String propertyId =
        (pathParts.isNotEmpty && pathParts[1].isNotEmpty ? pathParts[1] : "");
    String imageName = pathParts[2].substring(0, pathParts[2].indexOf('.'));

    PropertyImage image = PropertyImage(
      localPath: "",
      filePath: fullPath,
      url: "",
      propertyId: propertyId,
      order: 0,
      isDefault: true,
    );
    return image;
  }

  factory PropertyImage.fromJson(String id, Map<String, dynamic> json) {
    var propertyImage = _$PropertyImageFromJson(json);
    propertyImage.id = id;
    return propertyImage;
  }

  Map<String, dynamic> toJson() => _$PropertyImageToJson(this);
}

class PropertyImageList {
  List<PropertyImage> list = List.empty(growable: true);

  PropertyImageList(this.list) {
    _sort();
  }

  void _sort() {
    list.sort((left, right) {
      // first sort by order field, then alphabetically (for backwards compatibility)
      int diff = left.order!.compareTo(right.order!);
      if (diff == 0) {
        diff = left.filePath
            .toString()
            .toLowerCase()
            .compareTo(right.filePath.toString().toLowerCase());
      }
      return diff;
    });
  }

  void addPropertyImage(PropertyImage propertyImage) {
    list.add(propertyImage);
    _sort();
  }

  PropertyImage getDefault() {
    return list[0];
  }

  factory PropertyImageList.fromSnapshot(
      QuerySnapshot<Map<String, dynamic>> s) {
    List<PropertyImage> list = s.docs.map<PropertyImage>((ds) {
      PropertyImage image = PropertyImage.fromJson(ds.id, ds.data());
      return image;
    }).toList();
    return PropertyImageList(list);
  }

  factory PropertyImageList.fromListResult(ListResult listResult) {
    List<PropertyImage>? list = listResult.items.map((ref) {
      return PropertyImage.fromRef(ref);
    }).toList();
    return PropertyImageList(list);
  }
}
