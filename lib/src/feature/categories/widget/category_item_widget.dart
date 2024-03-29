import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/octopus.dart';
import 'package:repit/src/common/router/routes.dart';
import 'package:repit/src/core/localization/localization.dart';

import 'package:repit/src/feature/categories/bloc/categories_bloc.dart';
import 'package:repit/src/feature/categories/model/category_entity.dart';

///Enum for category card
enum CardAction {
  /// Edit category
  edit,

  /// Delete Category
  delete
}

///Item in categories list UI
class CategoryItemWidget extends StatefulWidget {
  ///Flag about if categories list is in Edit Mode
  final bool editMode;

  ///CategoryEntity
  final CategoryEntity category;

  ///Animation for check box, when Edit Mode choose
  final Animation<Offset> animation;

  ///Callback for edit in categories item
  final VoidCallback onEdit;

  /// Creates a CategoryItemWidget.
  const CategoryItemWidget({
    required this.editMode,
    required this.category,
    required this.animation,
    required this.onEdit,
    super.key,
  });

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  bool checkedForDelete = false;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            child: SlideTransition(
              position: widget.animation,
              child: Checkbox(
                checkColor: Theme.of(context).colorScheme.secondary,
                value: checkedForDelete,
                onChanged: (_) {
                  setState(() {
                    if (!checkedForDelete) {
                      checkedForDelete = true;
                      context
                          .read<CategoriesBloc>()
                          .add(MarkOnDelete(widget.category.id, mark: true));
                    } else {
                      checkedForDelete = false;
                      context
                          .read<CategoriesBloc>()
                          .add(MarkOnDelete(widget.category.id, mark: false));
                    }
                  });
                },
              ),
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.only(
              left: widget.editMode ? 50 : 0,
            ),
            child: InkWell(
              onTap: () {
                context.octopus.setState(
                  (state) => state
                    ..add(
                      Routes.cards.node(
                        arguments: {'category': widget.category.name},
                      )..extra["categoryId"] = widget.category.id,
                    ),
                );
              },
              child: Card(
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
                          Text(
                            widget.category.name,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          const Spacer(),
                          PopupMenuButton<CardAction>(
                            onSelected: (value) {
                              if (value == CardAction.delete) {
                                context.read<CategoriesBloc>().add(
                                      RemoveCategory(widget.category.id),
                                    );
                              }
                              if (value == CardAction.edit) {
                                widget.onEdit();
                              }
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
              ),
            ),
          ),
        ],
      );
}
