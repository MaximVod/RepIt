// ignore_for_file: public_member_api_docs

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/cards/data/cards_repository.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

///States for logic with cards
sealed class CardsState {}

class CardsIdle implements CardsState {
  CardsIdle();
}

class CardsLoading implements CardsState {
  CardsLoading();
}

class CardsFetched implements CardsState {
  final List<CardEntity> cards;
  CardsFetched(this.cards);
}

class CardsFailure implements CardsState {
  final String error;
  CardsFailure(this.error);
}

///Events for logic with cards
sealed class CardsEvent {}

class FetchCards implements CardsEvent {
  final int categoryId;
  FetchCards(this.categoryId);
}

class AddCards implements CardsEvent {
  final CardEntity card;
  AddCards(this.card);
}

class RemoveCard implements CardsEvent {
  final int cardId;
  RemoveCard(this.cardId);
}

class SetIsFavorite implements CardsEvent {
  final int cardId;
  final bool isFavorite;
  SetIsFavorite(this.cardId, {required this.isFavorite});
}

///Cards BLoC

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final CardsRepository _cardsRepository;

  CardsBloc(CardsRepository cardsRepository)
      : _cardsRepository = cardsRepository,
        super(CardsIdle()) {
    on<CardsEvent>(
      (event, emitter) => switch (event) {
        FetchCards() => _fetchCards(emitter, event.categoryId),
        AddCards() => _addCard(emitter, event.card),
        RemoveCard() => _removeCard(emitter, event.cardId),
        SetIsFavorite() => _setIsFavoriteCard(
            emitter,
            event.cardId,
            isFavoriteCard: event.isFavorite,
          )
      },
      transformer: bloc_concurrency.droppable(),
    );
  }

  Future<void> _fetchCards(Emitter<CardsState> emitter, int categoryId) async {
    try {
      emitter(CardsLoading());
      final cards = await _cardsRepository.getCardsById(categoryId);
      return emitter(CardsFetched(cards));
    } on Object catch (error) {
      emitter(
        CardsFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _addCard(
    Emitter<CardsState> emitter,
    CardEntity card,
  ) async {
    try {
      emitter(CardsLoading());
      await _cardsRepository.addCard(card);
      final cards = await _cardsRepository.getCardsById(card.categoryId);
      return emitter(CardsFetched(cards));
    } on Object catch (error) {
      emitter(
        CardsFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _removeCard(
    Emitter<CardsState> emitter,
    int cardId,
  ) async {
    try {
      emitter(CardsLoading());
      await _cardsRepository.removeCard(cardId);
    } on Object catch (error) {
      emitter(
        CardsFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _setIsFavoriteCard(
    Emitter<CardsState> emitter,
    int cardId, {
    required bool isFavoriteCard,
  }) async {
    try {
      await _cardsRepository.setFavoriteCard(
        cardId,
        isFavorite: isFavoriteCard,
      );
    } on Object catch (error) {
      emitter(
        CardsFailure(error.toString()),
      );
      rethrow;
    }
  }
}
