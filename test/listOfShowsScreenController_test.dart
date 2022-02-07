import 'package:flutter_test/flutter_test.dart';
import 'package:tv_shows/Controllers/ListOfShowsScreenController.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Routers/ListOfShowsRouter.dart';
import 'package:tv_shows/Services/ShowsApi.dart';

void main() {
  group("listOfShowsScreenControllerTests", () {
    test("given there is no authentication token, getShows returns before doing anything else", () async {
      // Setup

      // We don't set an auth token in the storage
      final storage = MockSecureLocalStorage();
      final showsApi = MockShowsApi();

      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      // Test
      await controller.getShows();

      // Verify
      expect(controller.shows.isEmpty, true);
    });

    test("given the getShows call returns new data, update the data", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("token", "validToken");

      final showsApi = MockShowsApi();

      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      // Test
      await controller.getShows();

      // Verify
      expect(controller.shows.isNotEmpty, true);
    });

    test("calling logout removes the email from secure storage", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("email", "someEmail");

      final showsApi = MockShowsApi();
      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      // Test
      controller.logout();

      // Verify
      expect(await storage.read("email"), null);
    });

    test("calling logout removes the password from secure storage", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("password", "somePassword");

      final showsApi = MockShowsApi();
      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      // Test
      controller.logout();

      // Verify
      expect(await storage.read("password"), null);
    });

    test("calling logout removes the token from secure storage", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      storage.write("token", "validToken");

      final showsApi = MockShowsApi();
      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      // Test
      controller.logout();

      // Verify
      expect(await storage.read("token"), null);
    });

    test("calling logout returns the user to login screen", () async {
      // Setup
      final storage = MockSecureLocalStorage();
      final router = MockListOfShowsRouter();
      final showsApi = MockShowsApi();

      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      controller.router = router;

      // Test
      controller.logout();

      // Verify
      expect(router.returnedToLoginScreen, true);
    });

    test("calling navigateToShowDetailsScreen shows the showDetailsScreen", () {
      // Setup
      final storage = MockSecureLocalStorage();
      final router = MockListOfShowsRouter();
      final showsApi = MockShowsApi();

      final controller = ListOfShowsScreenController(
        secureLocalStorage: storage,
        showsApi: showsApi,
      );

      controller.router = router;

      final ShowModel show = ShowModel(id: "id", title: "title", imageUrl: "imageUrl", likesCount: 1);

      // Test
      controller.navigateToShowDetailsScreen(show);

      // Verify
      expect(router.navigatedToShowDetailsScreen, true);
    });
  });
}
