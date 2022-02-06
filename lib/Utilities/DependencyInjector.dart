import 'package:tv_shows/Controllers/LoginScreenController.dart';
import 'package:tv_shows/Managers/LocalStorage.dart';
import 'package:tv_shows/Screens/LoginScreen.dart';
import 'package:tv_shows/Screens/MainScreen.dart';
import 'package:tv_shows/Services/UserApi.dart';

// This is the first time I'm doing dependency injection at this level. This approach (one DependencyInjector class) seems good enough
// for a small scale app such as this one, but if we had a bigger app with lots of features, we should probably create several
// classes such as this one to organize the code a bit better.

class DependencyInjector {
  const DependencyInjector();

  LoginScreen makeLoginScreen() {
    final controller = LoginScreenController(
      userApi: UserApi.shared,
      localStorage: LocalStorage.shared,
    );
    // we will set the router in the build method of LoginScreen, since we need the LoginScreen context
    return LoginScreen(controller: controller);
  }

  MainScreen makeMainScreen() {
    return const MainScreen();
  }
}
