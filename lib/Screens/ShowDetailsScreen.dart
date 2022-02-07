import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/Controllers/ShowDetailsScreenController.dart';
import 'package:tv_shows/Routers/ShowDetailsRouter.dart';
import 'package:tv_shows/Utilities/Constants.dart';
import 'package:tv_shows/Widgets/EpisodeRow.dart';

class ShowDetailsScreen extends StatelessWidget {
  final ShowDetailsScreenController controller;

  const ShowDetailsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.router ??= ShowDetailsRouter(context);
    return ChangeNotifierProvider<ShowDetailsScreenController>(
      create: (ctx) => controller,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: RefreshIndicator(
          onRefresh: controller.getShowDetails,
          color: Theme.of(context).primaryColor,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: PADDING),
                  child: IconButton(
                    onPressed: controller.returnToListOfShows,
                    iconSize: 40,
                    padding: const EdgeInsets.all(0),
                    icon: SvgPicture.asset("assets/icons/ic-navigate-back.svg"),
                  ),
                ),
                expandedHeight: 359,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Consumer<ShowDetailsScreenController>(builder: (context, controller, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.white,
                              ],
                              stops: const [0, 0.2],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ).createShader(rect);
                          },
                          child: CachedNetworkImage(
                            imageUrl: controller.selectedShow.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (ctx, _, __) => const Icon(Icons.error),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: LARGE_PADDING),
                      child: Consumer<ShowDetailsScreenController>(builder: (context, controller, child) {
                        return Text(
                          controller.selectedShow.title,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Color(0xFF2E2E2E),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: LARGE_PADDING, vertical: PADDING),
                      child: Consumer<ShowDetailsScreenController>(builder: (context, controller, child) {
                        return Text(
                          controller.selectedShow.description ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF505050),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: LARGE_PADDING, vertical: PADDING),
                      child: Row(
                        children: [
                          const Text(
                            "Episodes",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF2E2E2E),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Consumer<ShowDetailsScreenController>(
                            builder: (ctx, controller, child) => Text(
                              controller.episodes.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFFA0A0A0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ShowDetailsScreenController>(builder: (ctx, controller, child) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      final episode = controller.episodes[index];
                      return EpisodeRow(episode: episode);
                    },
                    childCount: controller.episodes.length,
                  ),
                );
              }),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              )
            ],
          ),
        ),
      ),
    );
  }
}
