import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ad.g.dart';

enum AdType { main, property, all }
enum AdSize { small, medium, large }

@JsonSerializable()
class Ad {
  String id;
  String url;
  String to;
  bool active;
  String name;
  AdType type;
  AdSize size;

  @JsonKey(fromJson: _DatetimeFromJson, toJson: _DatetimeToJson)
  DateTime? updatedAt;
  @JsonKey(fromJson: _DatetimeFromJson, toJson: _DatetimeToJson)
  DateTime? createdAt;

  Ad({
    this.id = "",
    this.url = "",
    this.to = "",
    this.active = false,
    this.name = "",
    this.type = AdType.property,
    this.size = AdSize.small
  }) {
    this.createdAt = this.createdAt ?? DateTime.now();
    this.updatedAt = this.createdAt ?? DateTime.now();
  }
  
  static DateTime? _DatetimeFromJson(Timestamp timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  static Timestamp _DatetimeToJson(DateTime? time) =>
      Timestamp.fromMillisecondsSinceEpoch(time!.millisecondsSinceEpoch);


  factory Ad.fromJson(String id, Map<String, dynamic> json) {
    var ad = _$AdFromJson(json);
    ad.id = id;
    return ad;
  }

  Map<String, dynamic> toJson() => _$AdToJson(this);
}



class AdList {
  List<Ad> list = List.empty(growable: true);

  AdList(this.list) {
    _sort();
  }

  // sort by updateAt
  void _sort() {
    list.sort((left, right) {
      int diff = 0;
      diff = (left.updatedAt != null && right.updatedAt != null) ? left.updatedAt!.compareTo(right.updatedAt!) : 0;
      return diff;
    });
  }

  void addAd(Ad ad) {
    list.add(ad);
    _sort();
  }

  Ad getDefault() {
    return list[0];
  }

  factory AdList.fromSnapshot(
      QuerySnapshot<Map<String, dynamic>> s) {
    List<Ad> list = s.docs.map<Ad>((ds) {
      Ad ad = Ad.fromJson(ds.id, ds.data());
      print('AD:5:active:${ad.active}');
      return ad;
    }).toList();
    return AdList(list);
  }
}

