import 'package:carousel_slider/carousel_slider.dart';
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
      const CardEntity(id: 1, key: "First", value: "Первый"),
      const CardEntity(id: 2, key: "Key", value: "Ключ"),
      const CardEntity(id: 3, key: "Value", value: "Значение"),
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
        body: Center(
          child: CarouselSlider.builder(
            options: CarouselOptions(
              height: 400,
              enlargeCenterPage: true,
              viewportFraction: 0.5,
              enlargeFactor: 0.3,
            ),
            itemCount: cards.length,
            itemBuilder: (
              BuildContext context,
              int itemIndex,
              int pageViewIndex,
            ) =>
                CardItem(card: cards[itemIndex]),
          ),
        ),
      ),
    );
  }
}
