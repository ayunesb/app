// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactReport _$ContactReportFromJson(Map<String, dynamic> json) =>
    ContactReport(
      action: json['action'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      email: json['email'] as String? ?? "",
      userName: json['userName'] as String? ?? "",
      adId: json['adId'] as String? ?? "",
    )..date = ContactReport._DatetimeFromJson(json['date'] as Timestamp);

Map<String, dynamic> _$ContactReportToJson(ContactReport instance) =>
    <String, dynamic>{
      'action': instance.action,
      'phone': instance.phone,
      'email': instance.email,
      'userName': instance.userName,
      'adId': instance.adId,
      'date': ContactReport._DatetimeToJson(instance.date),
    };
