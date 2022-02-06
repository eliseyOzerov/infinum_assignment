import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalStorageInterface {
  void securelyWrite(String key, String value);
  Future<String?> securelyRead(String key);
}

class LocalStorage implements LocalStorageInterface {
  static const LocalStorage shared = LocalStorage._();
  const LocalStorage._();

  @override
  void securelyWrite(String key, String value) {
    const storage = FlutterSecureStorage();
    storage.write(key: key, value: value);
  }

  @override
  Future<String?> securelyRead(String key) async {
    const storage = FlutterSecureStorage();
    return storage.read(key: key);
  }
}

class MockLocalStorage implements LocalStorageInterface {
  final Map<String, String> secureStorage = {};

  @override
  void securelyWrite(String key, String value) {
    secureStorage[key] = value;
  }

  @override
  Future<String?> securelyRead(String key) async {
    return secureStorage[key];
  }
}
