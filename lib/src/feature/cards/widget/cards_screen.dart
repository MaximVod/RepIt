import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/cards/widget/card_item.dart';

/// Screen to show cards by category
class CardsScreen extends StatefulWidget {
  ///Name of category
  final String categoryName;

  /// Create CardsScreen widget
  const CardsScreen({required this.categoryName, super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<CardEntity> cards = [
      const CardEntity(id: 1, key: "First", value: "Первый", categoryId: 2),
      const CardEntity(id: 2, key: "Key", value: "Ключ", categoryId: 2),
      const CardEntity(id: 3, key: "Value", value: "Значение", categoryId: 2),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.categoryName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: true,
                viewportFraction: 0.5,
              ),
              itemCount: cards.length,
              itemBuilder: (
                BuildContext context,
                int itemIndex,
                int pageViewIndex,
              ) =>
                  CardItem(card: cards[itemIndex]),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () => _showDialog(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    Localization.of(context).add_new_card,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showDialog() async => showGeneralDialog<String>(
        context: context,
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 250),
        transitionBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        ),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CreateCardDialog(),
      );
}

/// Dialog for create new Card
class CreateCardDialog extends StatefulWidget {
  /// {@macro sample_page}
  const CreateCardDialog({super.key});

  @override
  State<CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends State<CreateCardDialog> {
  /// TextField controller for card name
  final TextEditingController keyEditingController = TextEditingController();

  /// TextField controller for card value
  final TextEditingController valueEditingController = TextEditingController();

  bool validText = false;

  @override
  void initState() {
    keyEditingController.addListener(() {
      if (keyEditingController.text.length > 1 &&
          keyEditingController.text.length > 1) {
        setState(() {
          validText = true;
        });
      } else {
        setState(() {
          validText = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          Localization.of(context).create_new_card,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyEditingController,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: Localization.of(context).card_name_hint,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: valueEditingController,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: Localization.of(context).card_value_hint,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (validText) {
                Navigator.of(context).pop(keyEditingController.text);
              }
            },
            child: Text(
              Localization.of(context).create,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: validText
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                  ),
            ),
          ),
        ],
      );
}
