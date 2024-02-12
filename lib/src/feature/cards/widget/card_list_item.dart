import 'package:flutter/material.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        card.key,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const Spacer(),
                      // PopupMenuButton<CardAction>(
                      //   onSelected: (value) {
                      //     if (value == CardAction.delete) {
                      //       context.read<CategoriesBloc>().add(
                      //             RemoveCategory(widget.category.id),
                      //           );
                      //     }
                      //     if (value == CardAction.edit) {
                      //       widget.onEdit();
                      //     }
                      //   },
                      //   itemBuilder: (BuildContext context) =>
                      //       <PopupMenuEntry<CardAction>>[
                      //     const PopupMenuItem<CardAction>(
                      //       value: CardAction.edit,
                      //       child: Text('Edit'),
                      //     ),
                      //     const PopupMenuItem<CardAction>(
                      //       value: CardAction.delete,
                      //       child: Text('Delete'),
                      //     ),
                      //   ],
                      // ),
                    ],
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
            ),
          ),
        ),
      );
}
