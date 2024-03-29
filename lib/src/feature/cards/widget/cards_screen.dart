import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/common/widget/error_state.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/cards/bloc/cards_bloc.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/cards/widget/card_carousel_item.dart';
import 'package:repit/src/feature/cards/widget/card_list_item.dart';
import 'package:repit/src/feature/initialization/widget/dependencies_scope.dart';

/// Screen to show cards by category
class CardsScreen extends StatefulWidget {
  ///Name of category
  final String categoryName;

  ///Id of category
  final int categoryId;

  /// Create CardsScreen widget
  const CardsScreen({
    required this.categoryName,
    required this.categoryId,
    super.key,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool isListMode = false;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => CardsBloc(
          DependenciesScope.repositoriesOf(context).cardsRepository,
        )..add(FetchCards(widget.categoryId)),
        child: Scaffold(
          //TODO FAB for list state
          appBar: AppBar(
            title: Text(
              widget.categoryName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => setState(() {
                  isListMode = !isListMode;
                }),
                icon: Icon(
                  isListMode ? Icons.description_outlined : Icons.list,
                ),
              ),
            ],
          ),
          body: BlocBuilder<CardsBloc, CardsState>(
            builder: (context, state) => switch (state) {
              CardsIdle() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CardsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CardsFetched() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AnimatedCrossFade(
                        layoutBuilder: (
                          Widget topChild,
                          Key topChildKey,
                          Widget bottomChild,
                          Key bottomChildKey,
                        ) =>
                            Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              key: bottomChildKey,
                              left: 0.0,
                              top: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: bottomChild,
                            ),
                            Positioned(
                              key: topChildKey,
                              child: topChild,
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 300),
                        firstChild: Padding(
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
                                  (context, index) => CardListItemWidget(
                                    card: state.cards[index],
                                  ),
                                  childCount: state.cards.length,
                                ),
                              ),

                              /// Bottom padding
                              const SliverPadding(
                                padding: EdgeInsets.only(bottom: 16),
                              ),
                            ],
                          ),
                        ),
                        secondChild: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 400,
                                enableInfiniteScroll:
                                    state.cards.length >= 4 || false,
                                enlargeCenterPage: true,
                                viewportFraction: 0.5,
                                pauseAutoPlayInFiniteScroll: true,
                              ),
                              itemCount: state.cards.length,
                              itemBuilder: (
                                BuildContext context,
                                int itemIndex,
                                int pageViewIndex,
                              ) =>
                                  CardItem(card: state.cards[itemIndex]),
                            ),
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onPressed: () => _showDialog().then((value) {
                                if (value != null) {
                                  context.read<CardsBloc>().add(
                                        AddCards(
                                          CardEntity(
                                            categoryId: widget.categoryId,
                                            key: value[0],
                                            value: value[1],
                                          ),
                                        ),
                                      );
                                }
                              }),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    Localization.of(context).add_new_card,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        crossFadeState: isListMode
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ],
                ),
              CardsFailure() => ErrorState(
                  errorText: state.error,
                  onTryAgain: () => context
                      .read<CardsBloc>()
                      .add(FetchCards(widget.categoryId)),
                )
            },
          ),
        ),
      );

  Future<List<String>?> _showDialog() async => showGeneralDialog<List<String>>(
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
            const CreateCardDialog(),
      );
}

/// Dialog for create new Card
class CreateCardDialog extends StatefulWidget {
  /// {@macro sample_page}
  const CreateCardDialog({super.key});

  @override
  State<CreateCardDialog> createState() => _CreateCardDialogState();
}

class _CreateCardDialogState extends State<CreateCardDialog> {
  /// TextField controller for card name
  final TextEditingController keyEditingController = TextEditingController();

  /// TextField controller for card value
  final TextEditingController valueEditingController = TextEditingController();

  bool validText = false;

  @override
  void initState() {
    keyEditingController.addListener(() {
      if (keyEditingController.text.length > 1 &&
          keyEditingController.text.length > 1) {
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
        title: Text(
          Localization.of(context).create_new_card,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyEditingController,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: Localization.of(context).card_name_hint,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: valueEditingController,
              maxLength: 21,
              decoration: InputDecoration(
                hintText: Localization.of(context).card_value_hint,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (validText) {
                Navigator.of(context).pop(
                  [keyEditingController.text, valueEditingController.text],
                );
              }
            },
            child: Text(
              Localization.of(context).create,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: validText
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                  ),
            ),
          ),
        ],
      );
}
