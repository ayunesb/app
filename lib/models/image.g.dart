// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyImage _$PropertyImageFromJson(Map<String, dynamic> json) =>
    PropertyImage(
      id: json['id'] as String? ?? "",
      localPath: json['localPath'] as String?,
      filePath: json['filePath'] as String?,
      url: json['url'] as String?,
      propertyId: json['propertyId'] as String?,
      order: json['order'] as int?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$PropertyImageToJson(PropertyImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'localPath': instance.localPath,
      'filePath': instance.filePath,
      'url': instance.url,
      'propertyId': instance.propertyId,
      'order': instance.order,
      'isDefault': instance.isDefault,
    };
