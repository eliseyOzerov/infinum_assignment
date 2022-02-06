import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_shows/Screens/InitScreen.dart';
import 'package:tv_shows/Utilities/DependencyInjector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const DependencyInjector _di = DependencyInjector();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.karlaTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFFA0A0A0), letterSpacing: 0),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFDDDEDF))),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFDDDEDF))),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color(0xFFFFCCD5);
              } else {
                return const Color(0xFFFF758C);
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
            fixedSize: MaterialStateProperty.resolveWith((states) => const Size.fromHeight(48)),
            shape: MaterialStateProperty.resolveWith(
              (states) => const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            textStyle: MaterialStateProperty.resolveWith(
              (states) => GoogleFonts.karla(
                fontSize: 16,
              ),
            ),
          ),
        ),
        primaryColor: const Color(0xFFFF758C),
      ),
      home: const InitScreen(),
      routes: {
        "/login": (ctx) => _di.makeLoginScreen(),
        "/shows": (ctx) => _di.makeListOfShowsScreen(),
      },
    );
  }
}
