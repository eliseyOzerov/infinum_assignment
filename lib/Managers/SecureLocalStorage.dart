import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureLocalStorageInterface {
  void write(String key, String value);
  Future<String?> read(String key);
  void delete(String key);
}

class SecureLocalStorage implements SecureLocalStorageInterface {
  static const SecureLocalStorage shared = SecureLocalStorage._();
  const SecureLocalStorage._();

  @override
  void write(String key, String value) {
    const storage = FlutterSecureStorage();
    storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    const storage = FlutterSecureStorage();
    return storage.read(key: key);
  }

  @override
  void delete(String key) {
    const storage = FlutterSecureStorage();
    storage.delete(key: key);
  }
}

class MockSecureLocalStorage implements SecureLocalStorageInterface {
  final Map<String, String> secureStorage = {};

  @override
  void write(String key, String value) {
    secureStorage[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return secureStorage[key];
  }

  @override
  void delete(String key) {
    secureStorage.remove(key);
  }
}
