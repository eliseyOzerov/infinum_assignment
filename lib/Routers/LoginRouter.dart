import 'package:flutter/material.dart';

abstract class LoginRouterInterface {
  void navigateToMainScreen();
  void showLoginError();
}

class LoginRouter implements LoginRouterInterface {
  final BuildContext _context;

  LoginRouter(this._context);

  @override
  void navigateToMainScreen() {
    Navigator.of(_context).pushReplacementNamed("/shows");
  }

  @override
  void showLoginError() {
    const SnackBar snackBar = SnackBar(
      content: Text(
        "Login failed",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }
}

class MockLoginRouter implements LoginRouterInterface {
  bool navigatedToMainScreen = false;
  bool showedLoginError = false;

  @override
  void navigateToMainScreen() {
    navigatedToMainScreen = true;
  }

  @override
  void showLoginError() {
    showedLoginError = true;
  }
}
