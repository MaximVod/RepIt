import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/cards/bloc/cards_bloc.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/categories/widget/category_item_widget.dart';

///Widget of card in list
class CardListItemWidget extends StatefulWidget {
  ///Card entity
  final CardEntity card;

  ///Card item list constructor
  const CardListItemWidget({required this.card, super.key});

  @override
  State<CardListItemWidget> createState() => _CardListItemWidgetState();
}

class _CardListItemWidgetState extends State<CardListItemWidget> {
  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = widget.card.isFavorite;
    super.initState();
  }

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
                        widget.card.key,
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
                        widget.card.value,
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
                    onPressed: () => setState(() {
                      _isFavorite = !_isFavorite;
                      context.read<CardsBloc>().add(
                            SetIsFavorite(
                              widget.card.id,
                              isFavorite: _isFavorite,
                            ),
                          );
                    }),
                    icon: _isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
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
