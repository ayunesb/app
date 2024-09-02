import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:mockito/mockito.dart';

class FakeFirebaseStorage extends Fake implements FirebaseStorage {
  late Reference reference;

  FakeFirebaseStorage(String path, String fullPath, String url, List<Reference> list) {
    ListResult listResult = new FakeListResult(list);
    this.reference = FakeReference(path, fullPath, url, listResult);
  }

  @override
  Reference ref([String? path]) {
    return reference;
  }
}

class FakeListResult extends Fake implements ListResult {
  List<Reference> _items;

  FakeListResult(this._items);

  @override
  List<Reference> get items {
    return this._items;
  }
}

class FakeTaskSnapShot extends Fake implements TaskSnapshot {

}
class FakeTaskSnapshotPlatform extends Fake implements TaskSnapshotPlatform {

}

class FakeTaskPlatform extends Fake implements TaskPlatform {
  Exception? _exception;
  FakeTaskPlatform(this._exception);

  @override
  Future<TaskSnapshotPlatform> get onComplete {
    if(this._exception != null) {
      return Future.error(this._exception!);
    }
    return Future.value(FakeTaskSnapshotPlatform());
  }
}

class FakeUploadTask extends Fake implements UploadTask {
  final Exception? e;
  late TaskPlatform _delegate;
  FakeUploadTask({this.e = null}) {
    _delegate = FakeTaskPlatform(this.e);
  }



  @override
  Future<S> then<S>(FutureOr<S> Function(TaskSnapshot) onValue,
      {Function? onError}) => _delegate.onComplete.then((_) {
    return onValue(snapshot);
  }, onError: onError);

  @override

  TaskSnapshot get snapshot {
    return FakeTaskSnapShot();
  }
}

class FakeDownloadTask extends Fake implements DownloadTask {
  final Exception? e;
  late TaskPlatform _delegate;

  FakeDownloadTask({this.e = null}) {
    _delegate = FakeTaskPlatform(e);
  }

  @override
  Future<S> then<S>(FutureOr<S> Function(TaskSnapshot) onValue,
      {Function? onError}) => _delegate.onComplete.then((_) {
    return onValue(snapshot);
  }, onError: onError);

  @override

  TaskSnapshot get snapshot {
    return FakeTaskSnapShot();
  }
}

class FakeReference extends Mock implements Reference {
  String _name;
  String _fullPath;
  String _url;
  ListResult _listResult;
  FakeReference(this._name, this._fullPath, this._url, this._listResult);

  @override
  String get name {
    return this._name;
  }

  @override
  String get fullPath {
    return this._fullPath;
  }

  @override
  Future<String> getDownloadURL() => Future.value(this._url);

  @override
  Future<ListResult> listAll() async {
    return Future.value(_listResult);
  }

  @override
  UploadTask putFile(File file, [SettableMetadata? metadata]) {
    assert(file.absolute.existsSync());
    return FakeUploadTask();
  }

  @override   DownloadTask writeToFile(File file) {
    return FakeDownloadTask();
  }

  @override
  Reference child(String path) {
    return FakeReference(path, '${this._fullPath}/$path', '${this._url}/$path', FakeListResult([]));
  }
}
