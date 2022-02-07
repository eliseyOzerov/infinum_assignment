import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/Controllers/ListOfShowsScreenController.dart';
import 'package:tv_shows/Routers/ListOfShowsRouter.dart';
import 'package:tv_shows/Utilities/Constants.dart';
import 'package:tv_shows/Widgets/ShowRow.dart';

class ListOfShowsScreen extends StatelessWidget {
  final ListOfShowsScreenController controller;

  const ListOfShowsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.router ??= ListOfShowsRouter(context);
    return ChangeNotifierProvider<ListOfShowsScreenController>(
      create: (context) => controller,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(PADDING),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Shows",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.logout,
                      iconSize: 40,
                      padding: const EdgeInsets.all(0),
                      icon: SvgPicture.asset("assets/icons/ic-logout.svg"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Consumer<ListOfShowsScreenController>(
                  builder: (ctx, controller, child) => RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    onRefresh: controller.getShows,
                    child: ListView.builder(
                      itemCount: controller.shows.length,
                      itemBuilder: (ctx, index) {
                        final show = controller.shows[index];
                        return ShowRow(show: show);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
