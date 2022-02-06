import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Utilities/Constants.dart';

abstract class ShowsApiInterface {
  Future<List<ShowModel>?> getShows(String authToken);
}

class ShowsApi implements ShowsApiInterface {
  static const ShowsApi shared = ShowsApi._();
  const ShowsApi._();

  @override
  Future<List<ShowModel>?> getShows(String authToken) async {
    try {
      // We could use interceptors to get the authentication token, but the problem with that idea is that the getShows method
      // doesn't really need to know where the authentication token comes from and it doesn't need to contain the logic for its retrieval.
      // It only needs it to send the request. Therefore, I've decided it's best to send the token as a parameter to the getShows function
      // when called from the controller.
      //
      // final Dio dio = Dio()..interceptors.add(InterceptorsWrapper(
      //   onRequest: (options, handler) {
      //     const storage = LocalStorage.shared;
      //     storage.securelyRead("token").then((value) {
      //       if (value != null) {
      //         options.headers["Authentication"] = value;
      //         handler.next(options);
      //       } else {
      //         log("auth token not found");
      //         final error = DioError(requestOptions: options, type: DioErrorType.cancel);
      //         handler.reject(error);
      //       }
      //     });
      //   },
      // ));
      final dio = Dio()..options.headers["Authentication"] = authToken;
      final Response<Map<String, dynamic>> response = await dio.get("$BASE_URL/api/shows");

      try {
        final data = response.data!["data"];

        final List<ShowModel> shows = [];

        for (final item in data) {
          final show = ShowModel.fromMap(item);
          show.imageUrl = BASE_URL + show.imageUrl;
          shows.add(show);
        }

        return shows;
      } catch (e) {
        // If the response isn't structured as expected, the parsing should fail.
        log(e.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }
}

class MockShowsApi implements ShowsApiInterface {
  @override
  Future<List<ShowModel>?> getShows(String authToken) async {
    if (authToken == "validToken") {
      return [
        ShowModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          likesCount: 1,
        ),
        ShowModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          likesCount: 1,
        ),
        ShowModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          likesCount: 1,
        ),
      ];
    }
  }
}
