import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/database_service.dart';

import '../firebase_mocks/firebase_firestore_mocks.dart';
import '../util/json_utils.dart';

void main() {
  late DatabaseService subject;

  Future<void> setUp() async {
    Property property1 = Property.fromJson(JsonUtils.loadJsonFromFile('./test/service/property1.json'));
    Property property2 = Property.fromJson(JsonUtils.loadJsonFromFile('./test/service/property2.json'));
    late List<Map<String, dynamic>> _propertyDocs = [
      property1.toJson(),
      property2.toJson(),
    ];

    Map<String, List<Map<String, dynamic>>> collections ={
      'properties': _propertyDocs
    };

    subject = DatabaseService(database: FakeFirebaseFirestore(collections: collections));
  }

  group('DatabaseService', () {
    test('should return all properties', () async {
      await setUp();
      PropertyList properties =
          await subject.getProperties(active: ActiveType.all);
      expect(properties.list.length, 2);
    });

    test('should return error on exception', () async {
      await setUp();
      PropertyList properties =
      await subject.getProperties(active: ActiveType.all);
      expect(properties.list.length, 2);
    });

    test('should return active properties', () async {
      await setUp();
      PropertyList properties = await subject.getProperties();
      expect(properties.list.length, 1);
      expect(properties.list[0].bedrooms, 2);
    });

    test('should not return inactive properties', () async {
      await setUp();
      PropertyList properties =
          await subject.getProperties(active: ActiveType.inactive);
      expect(properties.list.length, 1);
      expect(properties.list[0].bedrooms, 4);
    });
  });
}
