import 'package:tv_shows/Controllers/ListOfShowsScreenController.dart';
import 'package:tv_shows/Controllers/LoginScreenController.dart';
import 'package:tv_shows/Controllers/ShowDetailsScreenController.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Screens/ShowDetailsScreen.dart';
import 'package:tv_shows/Screens/LoginScreen.dart';
import 'package:tv_shows/Screens/ListOfShowsScreen.dart';
import 'package:tv_shows/Services/ShowsApi.dart';
import 'package:tv_shows/Services/UserApi.dart';

// This is the first time I'm doing dependency injection at this level. This approach (one DependencyInjector class) seems good enough
// for a small scale app such as this one, but if we had a bigger app with lots of features, we should probably create several
// classes such as this one to organize the code a bit better.

class DependencyInjector {
  const DependencyInjector();

  LoginScreen makeLoginScreen() {
    final controller = LoginScreenController(
      userApi: UserApi.shared,
      secureLocalStorage: SecureLocalStorage.shared,
    );
    // we will set the router in the build method of LoginScreen, since we need the LoginScreen context
    return LoginScreen(controller: controller);
  }

  ListOfShowsScreen makeListOfShowsScreen() {
    final controller = ListOfShowsScreenController(
      showsApi: ShowsApi.shared,
      secureLocalStorage: SecureLocalStorage.shared,
    );
    return ListOfShowsScreen(controller: controller);
  }

  ShowDetailsScreen makeShowDetailsScreen(ShowModel show) {
    final controller = ShowDetailsScreenController(
      showsApi: ShowsApi.shared,
    );
    return ShowDetailsScreen(controller: controller, show: show);
  }
}
