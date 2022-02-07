import 'package:flutter/material.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Utilities/DependencyInjector.dart';

abstract class ShowDetailsRouterInterface {
  void returnToListOfShows();
  void navigateToEpisodeDetails(EpisodeModel episode);
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
}
