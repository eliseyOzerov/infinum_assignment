import 'package:flutter_test/flutter_test.dart';
import 'package:tv_shows/Controllers/ShowDetailsScreenController.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Routers/ShowDetailsRouter.dart';
import 'package:tv_shows/Services/ShowsApi.dart';

void main() {
  group("showDetailsScreenControllerTests", () {
    test("calling returnToListOfShows returns to the list of shows", () {
      // Setup
      final userApi = MockShowsApi();
      final router = MockShowDetailsRouter();
      final localStorage = MockSecureLocalStorage();

      final show = ShowModel(id: "id", imageUrl: "imgurl", likesCount: 1, title: "title");

      final ShowDetailsScreenController loginController =
          ShowDetailsScreenController(showsApi: userApi, secureLocalStorage: localStorage, selectedShow: show);
      loginController.router = router;

      // Test
      loginController.returnToListOfShows();

      // Verify
      expect(router.returnedToListOfShows, true);
    });

    test("calling navigateToEpisodeDetails navigates to episode details", () {
      // Setup
      final userApi = MockShowsApi();
      final router = MockShowDetailsRouter();
      final localStorage = MockSecureLocalStorage();

      final show = ShowModel(id: "id", imageUrl: "imgurl", likesCount: 1, title: "title");

      final episode =
          EpisodeModel(id: "id", imageUrl: "imgurl", title: "title", description: "description", episodeNumber: "1", season: "1");

      final ShowDetailsScreenController loginController =
          ShowDetailsScreenController(showsApi: userApi, secureLocalStorage: localStorage, selectedShow: show);
      loginController.router = router;

      // Test
      loginController.navigateToEpisodeDetails(episode);

      // Verify
      expect(router.navigatedToEpisodeDetails, true);
    });

    test("calling navigateToAddWatchedEpisode navigates to adding a new episode", () {
      // Setup
      final userApi = MockShowsApi();
      final router = MockShowDetailsRouter();
      final localStorage = MockSecureLocalStorage();

      final show = ShowModel(id: "id", imageUrl: "imgurl", likesCount: 1, title: "title");

      final ShowDetailsScreenController loginController =
          ShowDetailsScreenController(showsApi: userApi, secureLocalStorage: localStorage, selectedShow: show);
      loginController.router = router;

      // Test
      loginController.navigateToAddWatchedEpisode();

      // Verify
      expect(router.navigatedToAddWatchedEpisode, true);
    });

    test("given there is no authentication token, getShowDetails returns before doing anything else", () async {
      // Setup

      // We don't set an auth token in the storage
      final storage = MockSecureLocalStorage();
      final showsApi = MockShowsApi();

      final show = ShowModel(id: "id", imageUrl: "imgurl", likesCount: 1, title: "title");

      final controller = ShowDetailsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
        selectedShow: show,
      );

      // Test
      await controller.getShowDetails();

      // Verify
      expect(identical(controller.selectedShow, show), true);
    });

    test("given the getShowDetails call returns new data, update the selected show data", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("token", "validToken");

      final showsApi = MockShowsApi();

      final show = ShowModel(id: "validId", imageUrl: "imgurl", likesCount: 1, title: "title");

      final controller = ShowDetailsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
        selectedShow: show,
      );

      // Test
      await controller.getShowDetails();

      // Verify
      expect(identical(controller.selectedShow, show), false);
    });

    test("given the getShowDetails and getEpisodes return new data, update the show episodes", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("token", "validToken");

      final showsApi = MockShowsApi();

      final show = ShowModel(id: "validId", imageUrl: "imgurl", likesCount: 1, title: "title");

      final controller = ShowDetailsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
        selectedShow: show,
      );

      // Test
      await controller.getShowDetails();

      // Verify
      expect(controller.episodes.isNotEmpty, true);
    });
  });
}
