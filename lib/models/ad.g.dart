// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ad _$AdFromJson(Map<String, dynamic> json) => Ad(
      id: json['id'] as String? ?? "",
      url: json['url'] as String? ?? "",
      to: json['to'] as String? ?? "",
      active: json['active'] as bool? ?? false,
      name: json['name'] as String? ?? "",
      type:
          $enumDecodeNullable(_$AdTypeEnumMap, json['type']) ?? AdType.property,
      size: $enumDecodeNullable(_$AdSizeEnumMap, json['size']) ?? AdSize.small,
    )
      ..updatedAt = Ad._DatetimeFromJson(json['updatedAt'] as Timestamp)
      ..createdAt = Ad._DatetimeFromJson(json['createdAt'] as Timestamp);

Map<String, dynamic> _$AdToJson(Ad instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'to': instance.to,
      'active': instance.active,
      'name': instance.name,
      'type': _$AdTypeEnumMap[instance.type]!,
      'size': _$AdSizeEnumMap[instance.size]!,
      'updatedAt': Ad._DatetimeToJson(instance.updatedAt),
      'createdAt': Ad._DatetimeToJson(instance.createdAt),
    };

const _$AdTypeEnumMap = {
  AdType.main: 'main',
  AdType.property: 'property',
  AdType.all: 'all',
};

const _$AdSizeEnumMap = {
  AdSize.small: 'small',
  AdSize.medium: 'medium',
  AdSize.large: 'large',
};
