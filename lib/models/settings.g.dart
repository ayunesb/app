// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      id: json['id'] as String? ?? "",
      type: $enumDecodeNullable(_$SettingsTypeEnumMap, json['type']) ??
          SettingsType.none,
      label: json['label'] as String? ?? "",
      value: json['value'] as String? ?? "",
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SettingsTypeEnumMap[instance.type]!,
      'label': instance.label,
      'value': instance.value,
    };

const _$SettingsTypeEnumMap = {
  SettingsType.none: 'none',
  SettingsType.agentPhone: 'agentPhone',
};
