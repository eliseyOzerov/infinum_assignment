import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv_shows/Models/EpisodeModel.dart';
import 'package:tv_shows/Utilities/Constants.dart';

class EpisodeRow extends StatelessWidget {
  final EpisodeModel episode;

  const EpisodeRow({required this.episode, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LARGE_PADDING, vertical: 18),
      child: Row(
        children: [
          Text(
            "S${episode.season} Ep${episode.episodeNumber}",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              episode.title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
          SvgPicture.asset("assets/icons/ic-navigation-chevron-right-medium.svg"),
        ],
      ),
    );
  }
}
