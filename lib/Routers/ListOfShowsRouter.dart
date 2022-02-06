import 'package:flutter/material.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Utilities/DependencyInjector.dart';

abstract class ListOfShowsRouterInterface {
  void returnToLoginScreen();
  void navigateToShowDetailsScreen(ShowModel show);
}

class ListOfShowsRouter implements ListOfShowsRouterInterface {
  final BuildContext _context;

  ListOfShowsRouter(this._context);

  @override
  void returnToLoginScreen() {
    Navigator.of(_context).pushReplacementNamed("/login");
  }

  @override
  void navigateToShowDetailsScreen(ShowModel show) {
    const di = DependencyInjector();
    final route = MaterialPageRoute(builder: (ctx) => di.makeShowDetailsScreen(show));
    Navigator.of(_context).push(route);
  }
}

class MockListOfShowsRouter implements ListOfShowsRouterInterface {
  bool navigatedToShowDetailsScreen = false;
  bool returnedToLoginScreen = false;

  @override
  void navigateToShowDetailsScreen(ShowModel show) {
    navigatedToShowDetailsScreen = true;
  }

  @override
  void returnToLoginScreen() {
    returnedToLoginScreen = true;
  }
}
