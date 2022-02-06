import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Routers/ListOfShowsRouter.dart';
import 'package:tv_shows/Services/ShowsApi.dart';

class ListOfShowsScreenController extends ChangeNotifier {
  final ShowsApiInterface showsApi;
  final SecureLocalStorageInterface secureLocalStorage;
  ListOfShowsRouterInterface? router;

  ListOfShowsScreenController({required this.showsApi, required this.secureLocalStorage}) {
    getShows();
  }

  // ---- State ---- //
  List<ShowModel> shows = [];

  // ---- Public methods ---- //
  Future<void> getShows() async {
    log("getShows");
    final String? token = await secureLocalStorage.read("token");

    if (token == null) {
      log("auth token hasn't been found");
      return;
    }

    final List<ShowModel>? shows = await showsApi.getShows(token);

    // Only update in case of new data for better UX. Potentially show an error if data was null.
    if (shows != null) {
      this.shows = shows;
      notifyListeners();
    }
  }

  void logout() {
    log("logout");
    _removeUserLoginData();
    _navigateToLogin();
  }

  void navigateToShowDetailsScreen(ShowModel show) {
    log("navigateToShowDetailsScreen");
    router?.navigateToShowDetailsScreen(show);
  }

  // ---- Private methods ---- //

  void _removeUserLoginData() {
    secureLocalStorage.delete("email");
    secureLocalStorage.delete("password");
    secureLocalStorage.delete("token");
  }

  void _navigateToLogin() {
    router?.returnToLoginScreen();
  }
}
