import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';
import 'package:repit/src/feature/cards/widget/cards_screen.dart';
import 'package:repit/src/feature/categories/widget/home_screen.dart';
import 'package:repit/src/feature/home/widget/home_screen.dart';

/// Routes for Octopus Navigator
enum Routes with OctopusRoute {
  /// Home Route
  home('home', title: 'Octopus'),

  /// Categories Route
  categories('categories', title: 'Octopus'),

  /// Cards Route
  cards('cards', title: 'Cards');

  const Routes(this.name, {this.title});

  @override
  final String name;

  @override
  final String? title;

  @override
  Widget builder(BuildContext context, OctopusState state, OctopusNode node) =>
      switch (this) {
        Routes.home => const HomeScreen(),
        Routes.categories => const CategoriesTab(),
        Routes.cards => CardsScreen(
            categoryName: node.arguments['category'] ?? "",
            categoryId: node.extra['categoryId']! as int,
          ),
      };

  /*
  @override
  Page<Object?> pageBuilder(BuildContext context, OctopusNode node) =>
      node.name.endsWith('-custom')
          ? CustomUserPage()
          : super.pageBuilder(context, node);
  */
}
