// ignore_for_file: public_member_api_docs

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/favorites/data/favorites_repository.dart';

///States for logic with favorites cards
sealed class FavoritesCardsState {}

class FavoritesCardsIdle implements FavoritesCardsState {
  FavoritesCardsIdle();
}

class FavoritesCardsLoading implements FavoritesCardsState {
  FavoritesCardsLoading();
}

class FavoritesCardsFetched implements FavoritesCardsState {
  final List<CardEntity> cards;
  FavoritesCardsFetched(this.cards);
}

class FavoritesCardsFailure implements FavoritesCardsState {
  final String error;
  FavoritesCardsFailure(this.error);
}

///Events for logic with favorites cards
sealed class FavoritesCardsEvent {}

class FetchFavCards implements FavoritesCardsEvent {
  FetchFavCards();
}

///Favorites Cards BLoC

class FavoritesCardsBloc
    extends Bloc<FavoritesCardsEvent, FavoritesCardsState> {
  final FavoritesRepository _favCardsRepository;

  FavoritesCardsBloc(FavoritesRepository favCardsRepository)
      : _favCardsRepository = favCardsRepository,
        super(FavoritesCardsIdle()) {
    on<FavoritesCardsEvent>(
      (event, emitter) =>
          switch (event) { FetchFavCards() => _fetchFavCards(emitter) },
      transformer: bloc_concurrency.droppable(),
    );
  }

  Future<void> _fetchFavCards(Emitter<FavoritesCardsState> emitter) async {
    try {
      emitter(FavoritesCardsLoading());
      final cards = await _favCardsRepository.getAllFavCards();
      return emitter(FavoritesCardsFetched(cards));
    } on Object catch (error) {
      emitter(
        FavoritesCardsFailure(error.toString()),
      );
      rethrow;
    }
  }
}
