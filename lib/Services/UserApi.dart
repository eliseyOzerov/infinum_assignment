import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tv_shows/Utilities/Constants.dart';

abstract class UserApiInterface {
  /// Returns the authentication token to be used with future requests.
  Future<String?> loginWithEmailAndPassword(String email, String password);
}

class UserApi implements UserApiInterface {
  static const UserApi shared = UserApi._();
  const UserApi._();

  @override
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final Response<Map<String, dynamic>> response = await Dio().post(
        "$BASE_URL/api/users/sessions",
        data: {
          "email": email,
          "password": password,
        },
      );

      try {
        return response.data!["data"]["token"];
      } catch (e) {
        // If the response isn't structured as expected, the parsing should fail as `null` isn't the correct value for the token.
        log(e.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }
}

class MockUserApi implements UserApiInterface {
  @override
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return null;
    } else {
      return "token";
    }
  }
}
