import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:paradigm_mex/models/image.dart';

class ImageStorageService {
  late FirebaseStorage _storage;
  static const String _baseFolder = 'paradigm-mx-properties-images';

  /// Constructor for ImageStorageServices
  ///
  /// It initiates a Firebase storage instance.
  /// Prerequisites: Firebase.initializeApp() must have been called before this
  ImageStorageService({FirebaseStorage? storage}) {
    _storage = storage ?? FirebaseStorage.instance;
  }

  /// Gets images for a property
  ///
  /// @param propertyId The ID or the property
  /// @return PropertyImageList containing all images for a property
  Future<PropertyImageList> getImagesForProperty(String propertyId) async {
    PropertyImageList list = PropertyImageList([]);
    Reference propertyRef = _storage.ref('$_baseFolder/$propertyId');
    try {
      ListResult response = await propertyRef.listAll();

      if (response.items.isNotEmpty) {
        for (Reference ref in response.items) {
          PropertyImage propertyImage = PropertyImage.fromRef(ref);
          String url = await ref.getDownloadURL();
          propertyImage.url = url;
          list.addPropertyImage(propertyImage);
        }
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
    return list;
  }

  Future<Map<String, PropertyImageList>> getAllImages() async {
    Map<String, PropertyImageList> propertyImages =
        Map<String, PropertyImageList>();
    Reference imageBucket = _storage.ref();
    try {
      ListResult bucketContents = await imageBucket.listAll();

      if (bucketContents.prefixes.isNotEmpty) {
        for (Reference ref in bucketContents.prefixes) {
          ListResult response = await ref.listAll();
          for (Reference ref in response.items) {
            PropertyImage propertyImage = PropertyImage.fromRef(ref);
            String? propertyId = propertyImage.propertyId;
            String url = await ref.getDownloadURL();
            propertyImage.url = url;
            PropertyImageList? list = propertyImages[propertyId] != null
                ? propertyImages[propertyId]
                : new PropertyImageList([]);
            list?.addPropertyImage(propertyImage);
            propertyImages[propertyId!] = list!;
          }
        }
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
    return propertyImages;
  }

  /// Upload an image for a property
  ///
  /// @param propertyImage The image of the property
  Future<PropertyImage?> uploadImageData(
      String propertyId, Uint8List data, String fileName) async {
    if (propertyId != null) {
      try {
        Reference imageRef = await createImageRef(propertyId, fileName);
        SettableMetadata metadata = getMetadata(propertyId);
        await imageRef.putData(data, metadata);

        String url = await imageRef.getDownloadURL();
        PropertyImage propertyImage = PropertyImage(
            localPath: fileName,
            filePath: imageRef.fullPath,
            url: url,
            propertyId: propertyId,
            order: 1,
            isDefault: false);
        return Future.value(propertyImage);
      } on FirebaseException catch (e) {
        debugPrint(e.message);
        return Future.error(
            'Error adding image for ${propertyId} ${e.message}');
      }
    }
    return Future.error('Invalid property ID ${propertyId}');
  }

  Future<String> uploadAdImageData(
      String adId, Uint8List data, String fileName) async {
    try {
      SettableMetadata metadata = SettableMetadata(
        customMetadata: <String, String>{'adId': adId},
      );
      Reference adsRef = _storage.ref('ads');
      Reference imageRef = adsRef.child('${adId}_${fileName}');

      await imageRef.putData(data, metadata);
      String url = await imageRef.getDownloadURL();

      return Future.value(url);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return Future.error('Error adding image for ${adId} ${e.message}');
    }
  }

  Future<int> getNewId(String propertyId) async {
    PropertyImageList _existingImages = await getImagesForProperty(propertyId);
    final int newId = _existingImages.list.length;
    return newId;
  }

  SettableMetadata getMetadata(String propertyId) {
    SettableMetadata metadata = SettableMetadata(
      customMetadata: <String, String>{'propertyId': propertyId},
    );

    return metadata;
  }

  Future<Reference> createImageRef(String propertyId, String fileName) async {
    Reference propertyRef = _storage.ref('$_baseFolder/$propertyId');
    Reference imageRef = propertyRef.child('${propertyId}_${fileName}');
    return imageRef;
  }

  /// Downloads a property image from Firebase to local storage
  ///
  /// @param propertyImage PropertyImage to download
  Future<void> downloadPropertyImageContents(
      PropertyImage propertyImage) async {
    File downloadToFile = File(propertyImage.localPath.toString());
    await downloadToFile.create();
    assert(downloadToFile.absolute.existsSync());
    try {
      await _storage.ref(propertyImage.filePath).writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Reference imageRefFromPropertyImage(PropertyImage propertyImage) {
    Reference propertyRef =
        _storage.ref('$_baseFolder/${propertyImage.propertyId}');
    Reference imageRef = propertyRef.child('${propertyImage.filePath}');
    return imageRef;
  }

  // paradigm-mx-properties-images/jHz4bsN5bpG4r3IpN9aW/jHz4bsN5bpG4r3IpN9aW_01.jpg
  Future<bool> deleteImage(PropertyImage propertyImage) async {
    try {
      String filePath = propertyImage.filePath!;
      String? imageName = filePath.substring(filePath.lastIndexOf("/") + 1);
      Reference propertyRef =
          _storage.ref('$_baseFolder/${propertyImage.propertyId}');
      Reference imageRef = propertyRef.child('${imageName}');

      await imageRef.delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      print(e.message);
      return Future.error(
          'Error deleting image for ${propertyImage.propertyId} ${e.message}');
    } catch (e) {
      print(e);
      return Future.error(
          'Error deleting image for ${propertyImage.propertyId} ${e}');
    }
  }

  Future<bool> imageExists(PropertyImage propertyImage) async {
    try {
      Reference ref = imageRefFromPropertyImage(propertyImage);
      await ref.getDownloadURL();
      return true;
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return false;
  }
}
