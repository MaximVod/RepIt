import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/home/bloc/categories_bloc.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

class CategoryItemWidget extends StatefulWidget {
  final bool editMode;
  final CategoryEntity category;
  final Animation<Offset> animation;

  const CategoryItemWidget(
      {super.key,
      required this.editMode,
      required this.category,
      required this.animation});

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  bool checkedForDelete = false;

  @override
  void initState() {
    super.initState();
  }

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
                    child: Text(
                      widget.category.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
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
