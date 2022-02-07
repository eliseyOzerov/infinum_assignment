import 'package:flutter/material.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Screens/AddWatchedEpisodeScreen.dart';
import 'package:tv_shows/Utilities/DependencyInjector.dart';

abstract class ShowDetailsRouterInterface {
  void returnToListOfShows();
  void navigateToEpisodeDetails(EpisodeModel episode);
  void navigateToAddWatchedEpisode();
}

class ShowDetailsRouter implements ShowDetailsRouterInterface {
  final BuildContext _context;
  ShowDetailsRouter(this._context);

  @override
  void returnToListOfShows() {
    Navigator.of(_context).pop();
  }

  @override
  void navigateToEpisodeDetails(EpisodeModel episode) {
    const di = DependencyInjector();
    final route = MaterialPageRoute(builder: (ctx) => di.makeEpisodeDetailsScreen(episode));
    Navigator.of(_context).push(route);
  }

  @override
  void navigateToAddWatchedEpisode() {
    const di = DependencyInjector();
    final route = MaterialPageRoute(builder: (ctx) => di.makeAddWatchedEpisodeScreen());
    Navigator.of(_context).push(route);
  }
}

class MockShowDetailsRouter implements ShowDetailsRouterInterface {
  bool navigatedToAddWatchedEpisode = false;
  bool navigatedToEpisodeDetails = false;
  bool returnedToListOfShows = false;
  @override
  void navigateToAddWatchedEpisode() {
    navigatedToAddWatchedEpisode = true;
  }

  @override
  void navigateToEpisodeDetails(EpisodeModel episode) {
    navigatedToEpisodeDetails = true;
  }

  @override
  void returnToListOfShows() {
    returnedToListOfShows = true;
  }
}
