import 'package:flutter/material.dart';

abstract class LoginRouterInterface {
  void navigateToMainScreen();
}

class LoginRouter implements LoginRouterInterface {
  final BuildContext _context;

  LoginRouter(this._context);

  @override
  void navigateToMainScreen() {
    Navigator.of(_context).pushReplacementNamed("/main");
  }
}

class MockLoginRouter implements LoginRouterInterface {
  bool navigatedToMainScreen = false;

  @override
  void navigateToMainScreen() {
    navigatedToMainScreen = true;
  }
}
