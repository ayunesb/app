import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeQuery<T> extends Fake implements Query<T> {
  late QuerySnapshot<T> _querySnapshot;
  Object field;
  Object? isEqualTo;
  Object? isNotEqualTo;
  Object? isLessThan;
  Object? isLessThanOrEqualTo;
  Object? isGreaterThan;
  Object? isGreaterThanOrEqualTo;
  Object? arrayContains;
  List<Object?>? arrayContainsAny;
  List<Object?>? whereIn;
  List<Object?>? whereNotIn;

  bool? isNull;
  FakeQuery(this._querySnapshot, this.field,
      {this.isEqualTo,
      this.isNotEqualTo,
      this.isLessThan,
      this.isLessThanOrEqualTo,
      this.isGreaterThan,
      this.isGreaterThanOrEqualTo,
      this.arrayContains,
      this.arrayContainsAny,
      this.whereIn,
      this.whereNotIn,
      this.isNull});

  @override
  Future<QuerySnapshot<T>> get([GetOptions? options]) {
    if (this.isEqualTo != null) {
      late QuerySnapshot<T> _filteredQuerySnapshot;
      late List<QueryDocumentSnapshot<Map<String, dynamic>>> _allDocs =
          _querySnapshot.docs
              .cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
      List<Map<String, dynamic>> _filtered = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in _allDocs) {
        Map<String, dynamic> doc = snapshot.data();
        if (doc[this.field] == this.isEqualTo) {
          _filtered.add(snapshot.data());
        }
      }

      _filteredQuerySnapshot = FakeQuerySnapShot(_filtered) as QuerySnapshot<T>;
      return Future.value(_filteredQuerySnapshot);
    }

    return Future.value(_querySnapshot);
  }
}

class FakeQuerySnapShot<T> extends Fake
    implements QuerySnapshot<Map<String, dynamic>> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs;

  FakeQuerySnapShot(List<Map<String, dynamic>> docList) {
    allDocs = docList.map((doc) => FakeQueryDocumentSnapshot(doc)).toList();
  }
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs {
    return this.allDocs;
  }
}

class FakeQueryDocumentSnapshot<T> extends Fake
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  late Map<String, dynamic> _data;

  FakeQueryDocumentSnapshot(this._data);

  @override
  Map<String, dynamic> data() {
    return this._data;
  }
}

class FakeCollection<T> extends Mock
    implements CollectionReference<T> {
  QuerySnapshot<T>? querySnapshot;

  FakeCollection(List<Map<String, dynamic>> docList) {
    FakeQuerySnapShot _fakeQuerySnapshot = FakeQuerySnapShot(docList);
    this.querySnapshot = _fakeQuerySnapshot as QuerySnapshot<T>?;
  }

  factory FakeCollection.fromDocs(List<Map<String, dynamic>> docList) {
    return FakeCollection(docList);
  }

  @override
  Future<QuerySnapshot<T>> get([GetOptions? options]) {
    return Future.value(querySnapshot);
  }

  @override
  Query<T> where(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return FakeQuery<T>(querySnapshot!, field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull);
  }
}

class FakeFirebaseFirestore<T> extends Fake implements FirebaseFirestore {
  late Map<String, CollectionReference<Map<String, dynamic>>> collections;

  FakeFirebaseFirestore({required Map<String, List<Map<String, dynamic>>> collections}) {
    Map<String, CollectionReference<Map<String, dynamic>>> _collections =
    collections.map((collectionName, docList) {
      return MapEntry(collectionName, FakeCollection.fromDocs(docList));
    });

    this.collections = _collections;
  }

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    CollectionReference<Map<String, dynamic>> coll = collections[collectionPath]
    as CollectionReference<Map<String, dynamic>>;
    return coll;
  }
}