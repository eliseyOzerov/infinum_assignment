import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/Controllers/UserController.dart';
import 'package:tv_shows/Utilities/Constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberUser = true;

  String get passwordSuffixIconPath {
    if (obscurePassword) {
      return "assets/icons/ic-hide-password.svg";
    } else {
      return "assets/icons/ic-characters-hide.svg";
    }
  }

  bool get isLoginEnabled {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void toggleRememberUser(bool? value) {
    setState(() {
      rememberUser = value!;
    });
  }

  void loginUser() {
    final UserController userController = Provider.of<UserController>(context, listen: false);
    final String email = emailController.text;
    final String password = passwordController.text;
    userController.loginUser(email, password);
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: emailController,
                  autocorrect: false,
                  decoration: const InputDecoration(labelText: "Email"),
                  cursorColor: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(PADDING, PADDING, PADDING, 0),
                child: TextField(
                  controller: passwordController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: SvgPicture.asset(passwordSuffixIconPath),
                      onPressed: togglePasswordVisibility,
                    ),
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  obscureText: obscurePassword,
                  style: const TextStyle(letterSpacing: 5),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0), // wanted to preserve the animations and still conform to the design
                    child: Checkbox(
                      value: rememberUser,
                      onChanged: toggleRememberUser,
                      fillColor: MaterialStateProperty.resolveWith((_) => Theme.of(context).primaryColor),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
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
                      child: TextButton(
                        onPressed: isLoginEnabled ? loginUser : null,
                        style: Theme.of(context).textButtonTheme.style,
                        child: const Text("LOG IN"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
