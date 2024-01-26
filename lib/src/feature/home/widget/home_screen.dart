import 'package:flutter/material.dart';

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
  List<String> categories = [
    "First category",
    "Second category",
    "Third Category",
  ];

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
              categories.add(value ?? "");
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
        body: CustomScrollView(
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
                      tileColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      title: Text(
                        categories[index],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                      ),
                    ),
                  ),
                  childCount: categories.length,
                ),
              ),
            ),

            /// Bottom padding
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 16),
            ),
          ],
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
