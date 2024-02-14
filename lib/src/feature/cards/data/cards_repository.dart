import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/feature/cards/data/cards_data_source.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

/// Repository interface for cards categories
abstract interface class CardsRepository {
  /// Get all card by category
  Future<List<CardEntity>> getCardsById(int categoryId);

  /// Add new card
  Future<void> addCard(CardEntity card);

  /// Remove card
  Future<void> removeCard(int id);

  /// Set card favorite or not
  Future<void> setFavoriteCard(int id, {required bool isFavorite});
}

/// Implementation of [CardsRepository]
class CardsRepositoryImpl implements CardsRepository {
  /// Date source instance of [CardsDataSource] for cards db
  final CardsDataSource _cardsDataSource;

  /// Constructor for repository
  CardsRepositoryImpl(this._cardsDataSource);

  @override
  Future<void> addCard(CardEntity card) => _cardsDataSource.createCard(
        CardsCompanion.insert(
          categoryId: card.categoryId,
          cardName: card.key,
          cardValue: card.value,
          isFavorite: Value<bool>(card.isFavorite),
        ),
      );

  @override
  Future<List<CardEntity>> getCardsById(int categoryId) async {
    final cardsList = await _cardsDataSource.getCardsByCategoryId(categoryId);
    return cardsList
        .map(
          (e) => CardEntity(
            id: e.id,
            categoryId: e.categoryId,
            key: e.cardName,
            value: e.cardValue,
            isFavorite: e.isFavorite,
          ),
        )
        .toList();
  }

  @override
  Future<void> removeCard(int id) => _cardsDataSource.removeCard(id);

  @override
  Future<void> setFavoriteCard(int id, {required bool isFavorite}) =>
      _cardsDataSource.setFavoriteCard(id, isFavorite: isFavorite);
}
