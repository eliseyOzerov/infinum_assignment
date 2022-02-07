import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Utilities/Constants.dart';

abstract class ShowsApiInterface {
  Future<List<ShowModel>?> getShows(String authToken);
  Future<ShowModel?> getShowDetails(String authToken, String showId);
  Future<List<EpisodeModel>?> getEpisodes(String authToken, String showId);
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

  @override
  Future<ShowModel?> getShowDetails(String authToken, String showId) async {
    try {
      final dio = Dio()..options.headers["Authentication"] = authToken;
      final Response<Map<String, dynamic>> response = await dio.get("$BASE_URL/api/shows/$showId");

      try {
        final data = response.data!["data"];
        final show = ShowModel.fromMap(data);
        show.imageUrl = BASE_URL + show.imageUrl;

        return show;
      } catch (e) {
        // If the response isn't structured as expected, the parsing should fail.
        log(e.toString());
      }
    } on DioError catch (e) {
      log(e.message);
    }
  }

  @override
  Future<List<EpisodeModel>?> getEpisodes(String authToken, String showId) async {
    try {
      final dio = Dio()..options.headers["Authentication"] = authToken;
      final Response<Map<String, dynamic>> response = await dio.get("$BASE_URL/api/shows/$showId/episodes");

      try {
        final data = response.data!["data"];

        final List<EpisodeModel> episodes = [];

        for (final item in data) {
          final episode = EpisodeModel.fromMap(item);
          episode.imageUrl = BASE_URL + episode.imageUrl;
          episodes.add(episode);
        }

        return episodes;
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

  @override
  Future<ShowModel?> getShowDetails(String authToken, String showId) async {
    if (authToken == "validToken" && showId == "validId") {
      return ShowModel(
        type: "shows",
        title: "Star Trek: Voyager",
        description: "Star Trek: Voyager is a science fiction television series set in the Star Trek universe."
            " that debuted in 1995 and ended its original run in 2001, with a classic \"ship in space\" formula like the preceding Star"
            " Trek: The Original Series (TOS) and Star Trek: The Next Generation (TNG).",
        id: "gPkzfXoJXX5TuTuM",
        likesCount: 26,
        imageUrl: "$BASE_URL/1532353336145-voyager.jpg",
      );
    }
  }

  @override
  Future<List<EpisodeModel>?> getEpisodes(String authToken, String showId) async {
    if (authToken == "validToken" && showId == "validId") {
      return [
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "1",
          season: "2",
        ),
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "2",
          season: "2",
        ),
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "3",
          season: "2",
        ),
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "1",
          season: "1",
        ),
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "2",
          season: "1",
        ),
        EpisodeModel(
          id: "someid",
          title: "sometitle",
          imageUrl: "someurl",
          description: "Serija koju nesmijem propustiti jer necu biti u toku",
          episodeNumber: "3",
          season: "1",
        ),
      ];
    }
  }
}
