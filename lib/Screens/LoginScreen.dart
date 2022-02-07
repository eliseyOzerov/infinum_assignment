import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/Controllers/LoginScreenController.dart';
import 'package:tv_shows/Routers/LoginRouter.dart';
import 'package:tv_shows/Utilities/Constants.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreenController controller;

  LoginScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.router ??= LoginRouter(context);

    // This Provider could also be set in the MyApp widget to provide the state throughout the app,
    // but since it only handles the login screen, we provide it here, at the lowest ancestor.
    //
    // If the login endpoint returned a User object, we could cache the response in local storage and fetch it when needed, we could also
    // store the object in the LoginController (if provided from MyApp), or a singleton object should the LoginController
    // be responsible only for the state of the LoginScreen. I'm not really sure which method would be the best.
    //
    // On one hand, using a MultiProvider in MyApp with all the different providers needed in the app makes sense - we could have feature based
    // controllers for things like login, user settings, movies, comments etc., but that would promote handling of individual screen
    // states inside the state classes, which might negatively impact performance since setState rebuilds the whole widget. On another
    // hand, shared state is useful because we don't need to cache the data. However, shared state only makes sense for data that isn't
    // persisted, but is needed on multiple levels of the widget hierarchy, in cases such as user onboarding, or any other flow that isn't
    // completed within one screen.
    //
    // There's a lot for me to learn regarding architecture and best practices, which is what I aim to do as a part of your team.
    return ChangeNotifierProvider<LoginScreenController>(
      create: (context) => controller,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 24 + MediaQuery.of(context).viewPadding.top),
                Center(child: SvgPicture.asset("assets/images/img-login-logo.svg")),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.fromLTRB(PADDING, PADDING, PADDING, 0),
                  child: TextField(
                    controller: controller.emailController,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: "Email"),
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(PADDING, PADDING, PADDING, 0),
                  child: Consumer<LoginScreenController>(builder: (context, controller, child) {
                    return TextField(
                      controller: controller.passwordController,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(controller.passwordSuffixIconPath),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: controller.obscurePassword,
                      style: const TextStyle(letterSpacing: 5),
                    );
                  }),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0), // wanted to preserve the animations and still conform to the design
                      child: Consumer<LoginScreenController>(builder: (context, controller, child) {
                        return Checkbox(
                          value: controller.rememberUser,
                          onChanged: controller.setRememberUser,
                          fillColor: MaterialStateProperty.resolveWith((_) => Theme.of(context).primaryColor),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        );
                      }),
                    ),
                    Text(
                      "Remember me",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: const Color(0xFF505050)),
                    ),
                  ],
                ),
                const SizedBox(height: PADDING),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: PADDING),
                  child: Row(
                    children: [
                      Expanded(
                        child: Consumer<LoginScreenController>(builder: (context, controller, child) {
                          return TextButton(
                            onPressed: controller.handleLoginPressed,
                            style: Theme.of(context).textButtonTheme.style,
                            child: Visibility(
                              visible: !controller.isLoggingIn,
                              child: const Text("LOG IN"),
                              replacement: const AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: Colors.white)),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
