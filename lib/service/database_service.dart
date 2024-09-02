import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paradigm_mex/models/property.dart';

import '../models/ad.dart';
import '../models/contact_report.dart';
import '../models/image.dart';
import '../models/settings.dart';

enum ActiveType { all, deleted, active, in_progress }

class DatabaseService {
  late FirebaseFirestore _database;
  final String _propertiesCollectionPath = 'properties';
  final String _amenititesCollectionPath = 'amenities';
  final String _adCollectionPath = 'ads';
  final String _settingsCollectionPath = 'settings';
  final String _typesCollectionPath = 'types';
  final String _statusesCollectionPath = 'statuses';
  final String _propertyImagesCollectionPath = 'propertyImgs';
  final String _reportsCollectionPath = 'reports';

  DatabaseService({FirebaseFirestore? database}) {
    _database = database ?? FirebaseFirestore.instance;
  }

  Future<PropertyList> getProperties(
      {ActiveType active = ActiveType.active}) async {
    try {

      CollectionReference<Map<String, dynamic>> _propertiesCollection =
          _database.collection(_propertiesCollectionPath);
      if (active == ActiveType.all) {
        QuerySnapshot<Map<String, dynamic>> snapshot =
            await _propertiesCollection.get();
        return Future.value(PropertyList.fromSnapshot(snapshot));
      } else {
        return _getPropertiesByStatus(_propertiesCollection, active);
      }
    } on FirebaseException catch (e, stacktrace) {
      return Future.error(e, stacktrace);
    }
  }

  Future<PropertyList> _getPropertiesByStatus(
      CollectionReference<Map<String, dynamic>> _propertiesCollection,
      ActiveType activeType) async {
    try {
      final Query<Map<String, dynamic>> query =
          _propertiesCollection.where('dbStatus', isEqualTo: activeType.name);
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return Future.value(PropertyList.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<List<PropertyEnum>> getAmenities() async {
    return _getPropertyEnumList(_amenititesCollectionPath);
  }

  Future<List<AppSettings>> getSettings() async {
    try {
      CollectionReference<Map<String, dynamic>> _settingsCollection =
      _database.collection(_settingsCollectionPath);

      QuerySnapshot<Map<String, dynamic>> snapshot = await _settingsCollection.get();
      return Future.value(AppSettings.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateSetting({required List<AppSettings> settings}) async {
    try {
      CollectionReference<Map<String, dynamic>> _settingsCollection =
      _database.collection(_settingsCollectionPath);
      for(AppSettings setting in settings) {
        await _settingsCollection.doc(setting.id).update(setting.toJson());
      }
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }




  Future<AdList> getAds({ActiveType active = ActiveType.active}) async {
    try {
      CollectionReference<Map<String, dynamic>> _adsCollection =
          _database.collection(_adCollectionPath);

      QuerySnapshot<Map<String, dynamic>> snapshot = await _adsCollection.get();
      return Future.value(AdList.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }


  Future<AdList> getAdsByStatus(
      bool active, AdType adType) async {
    CollectionReference<Map<String, dynamic>> _adsCollection =
    _database.collection(_adCollectionPath);
    try {
      print('AD:1}');
      Query<Map<String, dynamic>> query =
      _adsCollection.where('active', isEqualTo: active);
      print('AD:2:${query.toString()}');
      if(adType != AdType.all) {
        print('AD:3');
        query = query.where('type', isEqualTo: adType.name);
      }
      print('AD:4:${query.toString()}');
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return Future.value(AdList.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Ad> getAd() async {
    try {
      CollectionReference<Map<String, dynamic>> _adCollection =
          _database.collection(_adCollectionPath);
      final Query<Map<String, dynamic>> query =
          _adCollection.where('active', isEqualTo: true).where('type', isEqualTo: AdType.main.name);
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {

        var ds = snapshot.docs.first;
        Ad ad = Ad.fromJson(ds.id, ds.data());
        return Future.value(ad);
      }
      return Future.error("Not found");
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Ad> getAdById({required String adId}) async {
    try {
      CollectionReference<Map<String, dynamic>> _adsCollection =
      _database.collection(_adCollectionPath);
      DocumentSnapshot<Map<String, dynamic>> result =
      await _adsCollection.doc(adId).get();
      if (result.data() != null) {
        Ad ad = Ad.fromJson(adId, result.data()!);
        return ad;
      }
      return Future.error("Ad ${adId} not found");
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateAd({required Ad ad}) async {
    try {
      CollectionReference<Map<String, dynamic>> _adsCollection =
      _database.collection(_adCollectionPath);
      await _adsCollection.doc(ad.id).update(ad.toJson());
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }


  Future<bool> deleteAd({required Ad ad}) async {
    try {
      CollectionReference<Map<String, dynamic>> _adsCollection =
      _database.collection(_adCollectionPath);
      await _adsCollection.doc(ad.id).delete();
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<String> addAd({required Ad ad}) async {
    try {
      CollectionReference<Map<String, dynamic>> _adsCollection =
      _database.collection(_adCollectionPath);
      DocumentReference<Map<String, dynamic>> newId =
      await _adsCollection.add(ad.toJson());
      return newId.id;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }


  Future<List<PropertyEnum>> getStatuses() {
    return _getPropertyEnumList(_statusesCollectionPath);
  }

  Future<List<PropertyEnum>> getTypes() async {
    return _getPropertyEnumList(_typesCollectionPath);
  }

  Future<List<PropertyEnum>> _getPropertyEnumList(String collectionPath) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _getAllRowsFromCollection(collectionName: collectionPath);
    List<PropertyEnum> list = snapshot.docs.map<PropertyEnum>((ds) {
      return PropertyEnum.fromJson(ds.data());
    }).toList();
    return Future.value(list);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getAllRowsFromCollection(
      {required String collectionName}) async {
    try {
      CollectionReference<Map<String, dynamic>> _collection =
          _database.collection(collectionName);
      return _collection.get();
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Property> getProperty({required String propertyId}) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertiesCollection =
          _database.collection(_propertiesCollectionPath);
      DocumentSnapshot<Map<String, dynamic>> result =
          await _propertiesCollection.doc(propertyId).get();
      if (result.data() != null) {
        Property property = Property.fromJson(propertyId, result.data()!);
        return property;
      }
      return Future.error("Property ${propertyId} not found");
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<String> addProperty({required Property property}) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertiesCollection =
          _database.collection(_propertiesCollectionPath);
      DocumentReference<Map<String, dynamic>> newId =
          await _propertiesCollection.add(property.toJson());
      return newId.id;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateProperty({required Property property}) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertiesCollection =
          _database.collection(_propertiesCollectionPath);
      await _propertiesCollection.doc(property.id).update(property.toJson());
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<PropertyImageList> getPropertyImages(String propertyId) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertyImagesCollection =
          _database.collection(_propertyImagesCollectionPath);

      final Query<Map<String, dynamic>> query =
          _propertyImagesCollection.where('propertyId', isEqualTo: propertyId);
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      PropertyImageList imageList = PropertyImageList.fromSnapshot(snapshot);

      return Future.value(imageList);
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<PropertyImageList> getAllImages() async {
    try {
      CollectionReference<Map<String, dynamic>> _propertyImagesCollection =
          _database.collection(_propertyImagesCollectionPath);

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _propertyImagesCollection.get();
      return Future.value(PropertyImageList.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deletePropertyImage(String filePath) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertyImagesCollection =
          _database.collection(_propertyImagesCollectionPath);

      final Query<Map<String, dynamic>> query =
          _propertyImagesCollection.where('filePath', isEqualTo: filePath);
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        return doc.reference.delete();
      }
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> addPropertyImage(PropertyImage image) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertyImagesCollection =
          _database.collection(_propertyImagesCollectionPath);

      return _propertyImagesCollection.doc().set(image.toJson());
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updatePropertyImage({required PropertyImage image}) async {
    try {
      CollectionReference<Map<String, dynamic>> _propertyImagesCollection =
          _database.collection(_propertyImagesCollectionPath);

      await _propertyImagesCollection.doc(image.id).update(image.toJson());
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<ContactReport> getContactReport(
      {required String contactReportId}) async {
    try {
      CollectionReference<Map<String, dynamic>> _reportsCollection =
      _database.collection(_reportsCollectionPath);
      DocumentSnapshot<Map<String, dynamic>> result =
      await _reportsCollection.doc(contactReportId).get();
      if (result.data() != null) {
        ContactReport report =
        ContactReport.fromJson(contactReportId, result.data()!);
        return report;
      }
      return Future.error("Report ${contactReportId} not found");
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> updateContactReport(
      {required ContactReport contactReport}) async {
    try {
      CollectionReference<Map<String, dynamic>> _reportsCollection =
      _database.collection(_reportsCollectionPath);
      await _reportsCollection
          .doc(contactReport.id)
          .update(contactReport.toJson());
      return true;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<String> addContactReport(
      {required ContactReport contactReport}) async {
    try {
      CollectionReference<Map<String, dynamic>> _reportsCollection =
      _database.collection(_reportsCollectionPath);
      DocumentReference<Map<String, dynamic>> newId =
      await _reportsCollection.add(contactReport.toJson());
      return newId.id;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }
  /*
  adId: either an Id or 'all' for all agents
  startTime: date start range
  endTime: date end range
   */
  Future<ContactReportList> getContactReportSummaries(
      { String adId = 'all',
        required DateTime startTime,
        DateTime? endTime}) async {
    try {
      CollectionReference<Map<String, dynamic>> _reportsCollection =
      _database.collection(_reportsCollectionPath);
      Query<Map<String, dynamic>> query =
      _reportsCollection.where('date', isGreaterThanOrEqualTo: startTime);
      if (endTime != null) {
        query = query.where('date', isLessThanOrEqualTo: endTime);
      }
      if (adId != 'all') {
        query = query.where('adId', isEqualTo: adId);
      }
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      return Future.value(ContactReportList.fromSnapshot(snapshot));
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

}
