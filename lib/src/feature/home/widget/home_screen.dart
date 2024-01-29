import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/home/bloc/categories_bloc.dart';

import 'category_item_widget.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

///Enum for category card
enum CardAction {
  /// Edit category
  edit,

  /// Delete Category
  delete
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool editMode = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1.2, 0.0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            if (editMode) {
              context.read<CategoriesBloc>().add(RemoveCategories());
              setState(() {
                editMode = false;
              });
            } else {
              _showDialog().then((dialogValue) {
                if (dialogValue != null) {
                  context.read<CategoriesBloc>().add(AddCategory(dialogValue));
                }
              });
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(editMode ? Icons.delete : Icons.add),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Card Categories',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Open shopping cart',
              onPressed: () {
                setState(() {
                  if (!editMode) {
                    editMode = true;
                    _controller.forward();
                  } else {
                    editMode = false;
                    _controller.reverse();
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) => switch (state) {
            CategoriesIdle() => const SizedBox(),
            CategoriesLoading() => const SizedBox(),
            CategoriesFetched() => CustomScrollView(
                slivers: <Widget>[
                  /// Top padding
                  const SliverPadding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // Catalog root categories
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => CategoryItemWidget(
                          editMode: editMode,
                          category: state.categories[index],
                          animation: _offsetAnimation,
                        ),
                        childCount: state.categories.length,
                      ),
                    ),
                  ),

                  /// Bottom padding
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                ],
              ),
            CategoriesFailure() => const SizedBox(),
          },
        ),
      );

  Future<String?> _showDialog({bool isNew = true}) async =>
      showGeneralDialog<String>(
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
            NewCategoryDialog(
          isNew: isNew,
        ),
      );
}

/// Dialog for create new Category
class NewCategoryDialog extends StatelessWidget {
  /// {@macro sample_page}
  NewCategoryDialog({required this.isNew, super.key});

  /// Flag for determine if dialog uses for new Category or edit
  final bool isNew;

  /// TextField for category name
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: isNew
            ? const Text("Category name")
            : const Text("Edit category name"),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: 'Enter some text'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (textEditingController.text.length > 1) {
                Navigator.of(context).pop(textEditingController.text);
              }
            },
            child: isNew ? const Text("Ready") : const Text("Edit"),
          ),
        ],
      );
}
