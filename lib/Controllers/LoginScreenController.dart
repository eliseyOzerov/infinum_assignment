import 'package:flutter/material.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Routers/LoginRouter.dart';
import 'package:tv_shows/Services/UserApi.dart';

class LoginScreenController extends ChangeNotifier {
  // Although I've initially set these as late variables, there isn't really any need for a late modifier, since I can just pass
  // them in the constructor and not risk reassignment afterwards.
  final UserApiInterface userApi;
  final SecureLocalStorageInterface secureLocalStorage;
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
  //
  // Since we're initializing the router in the build method, we can't use late final. Instead it's going to be nullable with a null check
  // before assignment inside the build method. This might not be the best solution, but it's the simplest I could think of right now.
  LoginRouterInterface? router;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreenController({required this.userApi, required this.secureLocalStorage}) {
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

  // Calling this before logging in the user should lead to the automatic login of the user the next time the app launches.
  // Not sure where to test this, so I'll leave it out for now.
  void setRememberUser(bool? value) {
    rememberUser = value!;
    notifyListeners();
  }

  // This should take the user credentials, login the user, store their data securely and navigate to the next screen if login
  // was successul or return before doing anything else if it wasn't successful.
  Future<void> loginUser() async {
    isLoggingIn = true;
    notifyListeners();

    final String email = emailController.text;
    final String password = passwordController.text;

    final String? token = await userApi.loginWithEmailAndPassword(email, password);

    isLoggingIn = false;
    notifyListeners();

    if (token == null) {
      router?.showLoginError();
      return;
    }

    _securelyStoreLoginData(email, password, token);

    router?.navigateToMainScreen();
  }

  // ---- Private methods ---- //

  void _securelyStoreLoginData(String email, String password, String token) {
    secureLocalStorage.write("email", email);
    secureLocalStorage.write("password", password);
    secureLocalStorage.write("token", token);
  }
}
