import 'package:flutter/material.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  // This is the only screen that initializes the app, and since it holds no UI, we hold the initialization logic right here.
  // I've also thought to use a FutureBuilder within the MyApp widget, but this approach feels less clustered.
  void _initialize(BuildContext context) {
    _chooseHomeRoute().then((value) {
      Navigator.of(context).pushReplacementNamed(value);
    });
  }

  Future<String> _chooseHomeRoute() async {
    const localStorage = SecureLocalStorage.shared;
    // There might be a problem with this approach, in particular if the user uninstalls the app, the token value will persist. One
    // potential solution would be to add a "firstRun" key to SharedPreferences. If that value is not set, we purge the keychain. I've
    // decided against that, since it seems to be how Firebase knows if the user is logged in even after a re-installation.
    final String? authToken = await localStorage.read("token");
    if (authToken != null) {
      return "/shows";
    } else {
      return "/login";
    }
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);
    return const Scaffold();
  }
}
