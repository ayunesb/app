import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

enum SettingsType {none,  agentPhone }

@JsonSerializable()
class AppSettings {
  String id;
  SettingsType type;
  String label;
  String value;


  AppSettings({
    this.id = "",
    this.type = SettingsType.none,
    this.label = "",
    this.value = ""
  });
  
  factory AppSettings.fromJson(String id, Map<String, dynamic> json) {
    var settings = _$AppSettingsFromJson(json);
    return settings;
  }

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  static List<AppSettings> fromSnapshot(
      QuerySnapshot<Map<String, dynamic>> s) {
    List<AppSettings> list = s.docs.map<AppSettings>((ds) {
      AppSettings settings = AppSettings.fromJson(ds.id, ds.data());
      return settings;
    }).toList();
    return list;
  }

  static AppSettings? getSetting(List<AppSettings> settings, SettingsType type) {
    try {
      return settings.firstWhere((setting) => setting.type == type);
    }
    catch(e) {
      return null;
    }
  }
}

