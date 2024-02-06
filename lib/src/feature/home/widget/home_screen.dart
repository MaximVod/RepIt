import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/common/widget/error_state.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/home/bloc/categories_bloc.dart';
import 'package:repit/src/feature/home/widget/category_item_widget.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ValueNotifier<bool> _name = ValueNotifier<bool>(false);

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
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _name,
        builder: (context, value, child) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            enableFeedback: false,
            elevation: 0,
            onPressed: () {
              if (value) {
                context.read<CategoriesBloc>().add(RemoveCategories());
                _name.value = false;
              } else {
                _showDialog().then((dialogValue) {
                  if (dialogValue != null) {
                    context
                        .read<CategoriesBloc>()
                        .add(AddCategory(dialogValue));
                  }
                });
              }
            },
            child: Icon(value ? Icons.delete : Icons.add),
          ),
          appBar: AppBar(
            title: Text(
              Localization.of(context).categories_card,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  if (!value) {
                    _name.value = true;
                    //_name.value = true;
                    _controller.forward();
                  } else {
                    _name.value = false;
                    // _name.value = false;
                    _controller.reverse();
                  }
                },
              ),
            ],
          ),
          body: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) => switch (state) {
              CategoriesIdle() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CategoriesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CategoriesFetched() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      /// Top padding
                      const SliverPadding(
                        padding: EdgeInsets.only(top: 16),
                      ),
                      // Catalog root categories
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => CategoryItemWidget(
                            editMode: value,
                            category: state.categories[index],
                            animation: _offsetAnimation,
                            onEdit: () =>
                                _showDialog(isNew: false).then((dialogValue) {
                              if (dialogValue != null) {
                                context.read<CategoriesBloc>().add(
                                      EditCategory(
                                        state.categories[index],
                                        dialogValue,
                                      ),
                                    );
                              }
                            }),
                          ),
                          childCount: state.categories.length,
                        ),
                      ),

                      /// Bottom padding
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 16),
                      ),
                    ],
                  ),
                ),
              CategoriesFailure() => ErrorState(
                  errorText: state.error,
                  onTryAgain: () =>
                      context.read<CategoriesBloc>().add(FetchAllCategories()),
                )
            },
          ),
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
class NewCategoryDialog extends StatefulWidget {
  /// {@macro sample_page}
  const NewCategoryDialog({required this.isNew, super.key});

  /// Flag for determine if dialog uses for new Category or edit
  final bool isNew;

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  /// TextField for category name
  final TextEditingController textEditingController = TextEditingController();

  bool validText = false;

  @override
  void initState() {
    textEditingController.addListener(() {
      if (textEditingController.text.length > 1) {
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
        title: widget.isNew
            ? Text(
                Localization.of(context).category_name,
              )
            : Text(
                Localization.of(context).edit_category_name,
              ),
        content: TextField(
          controller: textEditingController,
          maxLength: 21,
          decoration: InputDecoration(
            hintText: Localization.of(context).category_name_hint,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (validText) {
                Navigator.of(context).pop(textEditingController.text);
              }
            },
            child: widget.isNew
                ? Text(
                    Localization.of(context).ready,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: validText
                              ? Theme.of(context).cardColor
                              : Theme.of(context).focusColor,
                        ),
                  )
                : Text(
                    Localization.of(context).edit,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: validText
                              ? Theme.of(context).cardColor
                              : Theme.of(context).focusColor,
                        ),
                  ),
          ),
        ],
      );
}
