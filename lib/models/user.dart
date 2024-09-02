import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String phone;
  String email;

  User({
    this.id = "",
    this.name = "",
    this.phone = "",
    this.email = ""
    
  });
  

  factory User.fromJson(String id, Map<String, dynamic> json) {
    var user = _$UserFromJson(json);
    user.id = id;
    return user;
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

