import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/Controllers/ListOfShowsScreenController.dart';
import 'package:tv_shows/Models/ShowModel.dart';
import 'package:tv_shows/Utilities/Constants.dart';

class ShowRow extends StatelessWidget {
  final ShowModel show;

  const ShowRow({required this.show, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ListOfShowsScreenController>();

    return GestureDetector(
      onTap: () => controller.navigateToShowDetailsScreen(show),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PADDING, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: const Color(0xFFF7F9FA)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: CachedNetworkImage(
                  imageUrl: show.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => Container(color: Colors.grey),
                  errorWidget: (ctx, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PADDING, vertical: 5),
              child: Text(
                show.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF505050),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
