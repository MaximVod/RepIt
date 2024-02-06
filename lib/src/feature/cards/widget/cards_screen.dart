import 'package:flutter/material.dart';
import 'package:repit/src/feature/cards/widget/card_item.dart';

import '../model/card_entity.dart';

/// Screen to show cards by category
class CardsScreen extends StatelessWidget {
  ///Name of category
  final String categoryName;

  /// Create CardsScreen widget
  const CardsScreen({required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    List<CardEntity> cards = [
      CardEntity(id: 1, key: "First", value: "Первый"),
      CardEntity(id: 2, key: "Key", value: "Ключ"),
      CardEntity(id: 3, key: "Value", value: "Значение")
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categoryName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => CardItem(card: cards[index],),
              childCount: cards.length,
            ),
          ),],
        ),
      ),
    );
  }
}
