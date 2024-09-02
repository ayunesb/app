import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_report.g.dart';

@JsonSerializable()
class ContactReport {
  @JsonKey(ignore: true)
  String id;
  String action;
  String phone;
  String email;
  String userName;
  String adId;
  @JsonKey(fromJson: _DatetimeFromJson, toJson: _DatetimeToJson)
  DateTime? date;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String adName;


  ContactReport({
    this.id = "",
    this.action = "",
    this.phone = "",
    this.email = "",
    this.userName = "",
    this.adId = "",
    this.adName = "",
  }) {
    this.date = this.date ?? DateTime.now();
  }

  static DateTime? _DatetimeFromJson(Timestamp timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  static Timestamp _DatetimeToJson(DateTime? time) =>
      Timestamp.fromMillisecondsSinceEpoch(time!.millisecondsSinceEpoch);

  factory ContactReport.fromJson(String id, Map<String, dynamic> json) {
    var ContactReport = _$ContactReportFromJson(json);
    ContactReport.id = id;
    return ContactReport;
  }
  Map<String, dynamic> toJson() => _$ContactReportToJson(this);
}

class ContactReportList {
  late List<ContactReport> list = [];
  ContactReportList({required this.list});

  factory ContactReportList.fromSnapshot(
      QuerySnapshot<Map<String, dynamic>> s) {
    List<ContactReport> list = s.docs.map<ContactReport>((ds) {
      return ContactReport.fromJson(ds.id, ds.data());
    }).toList();
    return ContactReportList(list: list);
  }

  ContactReportList sortByDate(bool ascending) {
    this.list.sort((left, right) {
      if (ascending) {
        return left.date!.compareTo(right.date!);
      } else {
        return right.date!.compareTo(left.date!);
      }
    });
    return this;
  }

  ContactReportList sortByAdId(bool ascending) {
    this.list.sort((left, right) {
      if (ascending) {
        return left.adId.compareTo(right.adId);
      } else {
        return right.adId.compareTo(left.adId);
      }
    });
    return this;
  }
}
