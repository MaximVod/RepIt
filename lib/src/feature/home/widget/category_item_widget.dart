import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/home/bloc/categories_bloc.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

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
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          widget.category.name,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                        ),
                        const Spacer(),
                        PopupMenuButton<CardAction>(
                          onSelected: (value) {
                            if (value == CardAction.delete) {
                              context.read<CategoriesBloc>().add(
                                    RemoveCategory(widget.category),
                                  );
                            }
                            if (value == CardAction.edit) {
                              widget.onEdit();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<CardAction>>[
                            const PopupMenuItem<CardAction>(
                              value: CardAction.edit,
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<CardAction>(
                              value: CardAction.delete,
                              child: Text('Delete'),
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
        ],
      );
}
