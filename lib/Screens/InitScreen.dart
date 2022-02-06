import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv_shows/Managers/LocalStorage.dart';
import 'package:tv_shows/Utilities/DependencyInjector.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  static const DependencyInjector _di = DependencyInjector();

  // This is the only screen that initializes the app, and since it holds no UI, we hold the initialization logic right here.
  // I've also thought to use a FutureBuilder within the MyApp widget, but this approach feels less clustered.
  void _initialize(BuildContext context) {
    _chooseHomeRoute().then((value) {
      final route = MaterialPageRoute(builder: (context) => value);
      Navigator.of(context).pushReplacement(route);
    });
  }

  Future<Widget> _chooseHomeRoute() async {
    const localStorage = LocalStorage.shared;
    // There might be a problem with this approach, in particular if the user uninstalls the app, the token value will persist. One
    // potential solution would be to add a "firstRun" key to SharedPreferences. If that value is not set, we purge the keychain. I've
    // decided against that, since it seems to be how Firebase knows if the user is logged in even after a re-installation.
    final String? authToken = await localStorage.securelyRead("token");
    if (authToken != null) {
      return _di.makeMainScreen();
    } else {
      return _di.makeLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);
    return const Scaffold();
  }
}
