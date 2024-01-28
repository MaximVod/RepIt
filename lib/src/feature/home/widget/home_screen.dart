import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/home/bloc/categories_bloc.dart';

/// {@template sample_page}
/// SamplePage widget
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro sample_page}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: GestureDetector(
          onTap: () => showGeneralDialog<String>(
            context: context,
            barrierLabel: "Label",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: const Duration(milliseconds: 250),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
            pageBuilder: (context, animation, secondaryAnimation) =>
                NewCategoryDialog(),
          ).then((value) {
            setState(() {
              if (value != null) {
                context.read<CategoriesBloc>().add(AddCategory(value));
              }
            });
          }),
          child: SizedBox(
            height: 50,
            width: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Card Categories',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
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
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            title: Text(
                              state.categories[index].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                            ),
                          ),
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
}

/// Dialog for create new Category
class NewCategoryDialog extends StatelessWidget {
  /// {@macro sample_page}
  NewCategoryDialog({super.key});

  /// TextField for category name
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Category name"),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: 'Enter some text'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textEditingController.text);
            },
            child: const Text("Ready"),
          ),
        ],
      );
}
