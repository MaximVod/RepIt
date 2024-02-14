import 'package:flutter/material.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

import '../../../core/localization/localization.dart';
import '../../home/widget/category_item_widget.dart';

///Widget of card in list
class CardListItemWidget extends StatelessWidget {
  ///Card entity
  final CardEntity card;

  ///Card item list constructor
  const CardListItemWidget({required this.card, super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card.key,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        card.value,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                  ),
                  PopupMenuButton<CardAction>(
                    onSelected: (value) {
                      // if (value == CardAction.delete) {
                      //   context.read<CategoriesBloc>().add(
                      //     RemoveCategory(widget.category.id),
                      //   );
                      // }
                      // if (value == CardAction.edit) {
                      //   widget.onEdit();
                      // }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<CardAction>>[
                      PopupMenuItem<CardAction>(
                        value: CardAction.edit,
                        child: Text(Localization.of(context).edit),
                      ),
                      PopupMenuItem<CardAction>(
                        value: CardAction.delete,
                        child: Text(Localization.of(context).delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
