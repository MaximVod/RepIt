import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/components/database/src/tables/cards.dart';

part 'cards_data_source.g.dart';

/// Data source for cards
abstract interface class CardsDataSource {
  /// Get all card by category ID
  Future<List<Card>> getCardsByCategoryId(int categoryId);

  /// Add card to db
  Future<void> createCard(CardsCompanion cardsCompanion);

  /// Remove card to db
  Future<void> removeCard(int id);

  /// Set card favorite or not
  Future<void> setFavoriteCard(int cardId, {required bool isFavorite});
}

/// DAO categories
@DriftAccessor(tables: [Cards])
class CardsDao extends DatabaseAccessor<AppDatabase>
    with _$CardsDaoMixin
    implements CardsDataSource {
  /// Cards DAO constructor
  CardsDao(super.attachedDatabase);

  @override
  Future<void> createCard(CardsCompanion cardsCompanion) =>
      into(attachedDatabase.cards).insert(cardsCompanion);

  @override
  Future<void> removeCard(int id) async {
    await (delete(attachedDatabase.cards)..where((tbl) => tbl.id.isValue(id)))
        .go();
  }

  @override
  Future<List<Card>> getCardsByCategoryId(int categoryId) =>
      (select(attachedDatabase.cards)
            ..where((tbl) => tbl.categoryId.isValue(categoryId)))
          .get();

  @override
  Future<void> setFavoriteCard(int cardId, {required bool isFavorite}) async =>
      (update(attachedDatabase.cards)..where((tbl) => tbl.id.isValue(cardId)))
          .write(CardsCompanion(isFavorite: Value(isFavorite)));
}
