import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/service/image_storage_service.dart';
import 'package:test/test.dart';

import '../firebase_mocks/firebase_cloud_storage_mocks.dart';

void main() {
  late FirebaseStorage storage;
  late Reference propertyRef;
  late ImageStorageService subject;
  const String _baseFolder = 'paradigm-mx-properties-images';
  const String _propertyId = 'HMoFKW7bVgud1QFDyykv';
  late Reference image1Ref;
  late Reference image2Ref;

  Future<void> setUp() async {

    List<Reference> propertyRefList = [];
    image1Ref = FakeReference(
        'image_00.jpeg',
        '$_baseFolder/$_propertyId/image_00.jpeg',
        'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/paradigm-mx-properties-images%#image_02.jpeg?alt=media&token=d3151cbe-043b-43e9-b795-c3148b4a8e09',
        FakeListResult([]));
    image2Ref = FakeReference(
        'image_01.png',
        '$_baseFolder/$_propertyId/image_01.png',
        'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/paradigm-mx-properties-images%#image_01.png?alt=media&token=d3151cbe-043b-43e9-b795-c3148b4a8e09',
        FakeListResult([]));
    propertyRefList.add(image1Ref);
    propertyRefList.add(image2Ref);
    storage = FakeFirebaseStorage(_propertyId, '$_baseFolder/$_propertyId', 'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/paradigm-mx-properties-images%2FHMoFKW7bVgud1QFDyykv%', propertyRefList);

    subject = ImageStorageService(storage: storage);
  }

  group('ImageStorageService', () {
    test('should return a list or images for a property',
        () async {
      await setUp();
      PropertyImageList images =
          await subject.getImagesForProperty(_propertyId);
      expect(images.list.length, 2);
      expect(images.list[0].isDefault, true);
      expect(images.list[1].isDefault, false);
    });

    test('should upload an image for a property', () async {
      await setUp();
      String imageName = 'HMoFKW7bVgud1QFDyykv_02.png';
      File file = new File('./test/service/$imageName');
      PropertyImage img = PropertyImage(localPath: file.path,
        filePath: '${_baseFolder}/${_propertyId}/$imageName}',
        propertyId: _propertyId,
        url: _propertyId,
        order: 0,
        isDefault: false);
      PropertyImage? image = await subject.uploadFile(img);
      expect(image?.url, 'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/paradigm-mx-properties-images%2FHMoFKW7bVgud1QFDyykv%/HMoFKW7bVgud1QFDyykv_02' );
    });

    test('should download an image for a property', () async {
      await setUp();
      String imageName = 'HMoFKW7bVgud1QFDyykv_04.png';
      var _url = 'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/paradigm-mx-properties-images%#${imageName}?alt=media&token=d3151cbe-043b-43e9-b795-c3148b4a8e09';
      Reference newImageRef = FakeReference(
          imageName,
          '$_baseFolder/$_propertyId/$imageName',
          _url,
          FakeListResult([]));

      storage = FakeFirebaseStorage(newImageRef.name, newImageRef.fullPath, _url, [newImageRef]);
      subject = ImageStorageService(storage: storage);

      File file = new File('./test/service/$imageName');
      PropertyImage img = PropertyImage(localPath: file.path,
          filePath: '${_baseFolder}/${_propertyId}/$imageName',
          propertyId: _propertyId,
          url: _propertyId,
          order: 0,
          isDefault: false);
      await subject.downloadPropertyImageContents(img);
      expect(file.absolute.existsSync(), true);
      file.deleteSync();
    });
  });
}
