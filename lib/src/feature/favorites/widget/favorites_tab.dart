import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/common/widget/error_state.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/cards/widget/card_carousel_item.dart';
import 'package:repit/src/feature/favorites/bloc/favorites_bloc.dart';

///Tab for Favorites cards
class FavoritesTab extends StatelessWidget {
  ///Widget constructor
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        Localization.of(context).favorites,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      centerTitle: true,
    ),
    body: BlocBuilder<FavoritesCardsBloc, FavoritesCardsState>(
      builder: (context, state) => switch (state) {
        FavoritesCardsIdle() => const Center(
            child: CircularProgressIndicator(),
          ),
        FavoritesCardsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        FavoritesCardsFetched() => Center(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                height: 400,
                enableInfiniteScroll: state.cards.length >= 4 || false,
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
          ),
        FavoritesCardsFailure() => ErrorState(
            errorText: state.error,
            onTryAgain: () =>
                context.read<FavoritesCardsBloc>().add(FetchFavCards()),
          ),
      },
    ),
  );
}
