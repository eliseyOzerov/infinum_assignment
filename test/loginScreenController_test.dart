import 'package:flutter_test/flutter_test.dart';
import 'package:tv_shows/Controllers/LoginScreenController.dart';
import 'package:tv_shows/Managers/LocalStorage.dart';
import 'package:tv_shows/Routers/LoginRouter.dart';
import 'package:tv_shows/Services/UserApi.dart';

void main() {
  group("loginScreenControllerTests", () {
    test("given failed authentication, login returns before doing anything else", () async {
      // Setup
      // As far as I know, it is encouraged to setup the SUT every time before running the unit test, so that the initial state of it
      // is the same every time. This is ugly and could've been extracted into a method, had I found a different way to test this use case.
      //
      // Right now, I'm setting custom properties within the mock classes to determine if the methods had been called or not, and I can't
      // use the loginController object to test those properties, since it depends on interfaces that don't contain these properties.
      final userApi = MockUserApi();
      final router = MockLoginRouter();
      final localStorage = MockLocalStorage();

      final LoginScreenController loginController = LoginScreenController();
      loginController.router = router;
      loginController.userApi = userApi;
      loginController.localStorage = localStorage;

      loginController.emailController.text = "";
      loginController.passwordController.text = "";
      // Test
      await loginController.loginUser();
      // Verify
      expect(router.navigatedToMainScreen, false);
      expect(localStorage.secureStorage.containsKey("token"), false);
      // This test would be invalid if we added something between the userApi login call and the verification that the token is not null.
      // Besides, I'm not sure it even makes sense to test that something DOESN'T happen, so perhaps this test shouldn't even exist.
    });

    test("given successful authentication and remember me is true, loginUser saves user credentials to secure storage", () async {
      // Setup
      final userApi = MockUserApi();
      final router = MockLoginRouter();
      final localStorage = MockLocalStorage();

      final LoginScreenController loginController = LoginScreenController();
      loginController.router = router;
      loginController.userApi = userApi;
      loginController.localStorage = localStorage;

      // obviously these credentials would fail in the real world, but we're testing the saving of the credentials, not authentication
      loginController.emailController.text = "validemail";
      loginController.passwordController.text = "validpassword";
      // This is hardcoded to be true, but should that value change, the test would break, so we set it here.
      loginController.rememberUser = true;

      // Test
      await loginController.loginUser();

      // Verify
      expect(localStorage.secureStorage["email"] == "validemail", true);
      expect(localStorage.secureStorage["password"] == "validpassword", true);
      expect(localStorage.secureStorage["token"] == "token", true);
    });

    test("given successful verification, loginUser navigates to mainScreen", () async {
      // Setup
      final userApi = MockUserApi();
      final router = MockLoginRouter();
      final localStorage = MockLocalStorage();

      final LoginScreenController loginController = LoginScreenController();
      loginController.router = router;
      loginController.userApi = userApi;
      loginController.localStorage = localStorage;

      loginController.emailController.text = "validemail";
      loginController.passwordController.text = "validpassword";

      // Test
      await loginController.loginUser();

      // Verify
      // Perhaps a better way to test this would be in a widget test, but I added it anyway since I'm not doing widget tests right now.
      expect(router.navigatedToMainScreen, true);
    });
  });
}
