import 'package:flutter/material.dart';
import 'package:tv_shows/Managers/LocalStorage.dart';
import 'package:tv_shows/Routers/LoginRouter.dart';
import 'package:tv_shows/Services/UserApi.dart';

class LoginScreenController extends ChangeNotifier {
  late final UserApiInterface userApi;
  // We need the router to navigate to the next screen once the login has gone through. We could also use a local BuildContext variable, but that
  // would make the LoginController dependent on the BuildContext, meaning we can't test the navigation part of the login method since
  // we don't have a BuildContext when testing, unless I'm missing something. Also we can't substitute the routing implementation without
  // changing the loginUser method. We could set a global BuildContext from the MyApp widget, but as far as I know, that context wouldn't be the
  // same as the one from the LoginScreen build method, so that seems like a bad practice. Also, this follows the CleanSwift methodology
  // (ViewControllers, Interactors, **Routers**, Presenters, Workers etc) where this controller is the "Interactor" and "Presenter".
  //
  // We could also do the routing in the LoginScreen by returning a success boolean from the loginUser method,
  // but then we would need business logic in the LoginScreen (if successful go to main screen, otherwise show error),
  // or we could pass success/error callbacks to the loginUser method, but that's just ugly.
  late final LoginRouterInterface router;
  late final LocalStorageInterface localStorage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreenController() {
    emailController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
  }

  // ---- State ---- //

  bool obscurePassword = true;
  bool rememberUser = true;
  bool isLoggingIn = false;

  String get passwordSuffixIconPath {
    if (obscurePassword) {
      return "assets/icons/ic-hide-password.svg";
    } else {
      return "assets/icons/ic-characters-hide.svg";
    }
  }

  // Using this disables the login button if login isn't enabled
  Function()? get handleLoginPressed {
    return _isLoginEnabled ? loginUser : null;
  }

  bool get _isLoginEnabled {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  // ---- Public methods ---- //

  // This should toggle the password visibility. It's a purely UI method and has nothing to do with the login functionality, therefore
  // it should be tested in the widget tests and not the unit tests.
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // Calling this before logging in the user should lead to the automatic login of the user the next time the app launches. How to test this?
  //
  void setRememberUser(bool? value) {
    rememberUser = value!;
    notifyListeners();
  }

  // this should take the user credentials, login the user, store their data securely and navigate to the next screen if login
  // was successul or return before doing anything else if it wasn't successful
  Future<void> loginUser() async {
    isLoggingIn = true;
    notifyListeners();

    final String email = emailController.text;
    final String password = passwordController.text;

    final String? token = await userApi.loginWithEmailAndPassword(email, password);

    if (token == null) {
      // possibly notify user of an error
      return;
    }

    _securelyStoreLoginData(email, password, token);

    isLoggingIn = false;
    notifyListeners();

    router.navigateToMainScreen();
  }

  // ---- Private methods ---- //

  // This could be moved to some LocalStorage class in case we wanted to change the implementation later,
  // but I think FlutterSecureStorage is a good enough abstraction for now
  void _securelyStoreLoginData(String email, String password, String token) {
    localStorage.securelyWrite("email", email);
    localStorage.securelyWrite("password", password);
    localStorage.securelyWrite("token", token);
  }
}
