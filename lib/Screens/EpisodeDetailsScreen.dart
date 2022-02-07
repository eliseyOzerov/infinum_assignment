import 'package:flutter/material.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';

class EpisodeDetailsScreen extends StatelessWidget {
  final EpisodeModel episode;

  const EpisodeDetailsScreen({required this.episode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(episode.title),
      ),
    );
  }
}
