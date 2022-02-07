import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tv_shows/Managers/SecureLocalStorage.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Routers/ShowDetailsRouter.dart';
import 'package:tv_shows/Services/ShowsApi.dart';

class ShowDetailsScreenController extends ChangeNotifier {
  final ShowsApiInterface showsApi;
  final SecureLocalStorageInterface secureLocalStorage;
  ShowDetailsRouterInterface? router;

  ShowModel selectedShow;

  ShowDetailsScreenController({
    required this.showsApi,
    required this.secureLocalStorage,
    required this.selectedShow,
  }) {
    getShowDetails();
  }

  // ---- State ---- //

  List<EpisodeModel> episodes = [];

  // ---- Public methods ---- //

  void returnToListOfShows() {
    router?.returnToListOfShows();
  }

  void navigateToEpisodeDetails(EpisodeModel episode) {
    router?.navigateToEpisodeDetails(episode);
  }

  void navigateToAddWatchedEpisode() {
    router?.navigateToAddWatchedEpisode();
  }

  // We do have a problem with data not being persisted when returning to the previous screen due to the current architecture,
  // but this could easily be solved with caching in local storage.
  //
  // Initially, I wanted to sort the episodes, but since the episodeNumber and season are strings, I didn't have time to think of all
  // possibilities and how to sort them.

  /// Gets missing details (description, etc.) as well as the existing show episodes
  Future<void> getShowDetails() async {
    log("getShowDetails");
    final String? token = await secureLocalStorage.read("token");

    if (token == null) {
      log("auth token hasn't been found");
      return;
    }

    final String showId = selectedShow.id;

    final ShowModel? show = await showsApi.getShowDetails(token, showId);

    // Only update in case of new data for better UX. Potentially show an error if data was null.
    if (show != null) {
      selectedShow = show;
      notifyListeners();
    }

    final List<EpisodeModel>? episodes = await showsApi.getEpisodes(token, showId);

    if (episodes != null) {
      this.episodes = episodes;
      notifyListeners();
    }
  }
}
