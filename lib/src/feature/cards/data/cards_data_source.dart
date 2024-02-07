import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/components/database/src/tables/cards.dart';

part 'cards_data_source.g.dart';

/// Data source for cards
abstract interface class CardsDataSource {
  /// Get all categories
  Future<List<Card>> getCardsByCategoryId(int categoryId);

  /// Add category to db
  Future<void> createCard(CardsCompanion cardsCompanion);

  /// Add category to db
  Future<void> deleteCard(int id);
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
  Future<void> deleteCard(int id) async {
   await (delete(attachedDatabase.cards)
      ..where((tbl) => tbl.id.isValue(id)))
        .go();
  }

  @override
  Future<List<Card>> getCardsByCategoryId(int categoryId) =>
      (select(attachedDatabase.cards)
            ..where((tbl) => tbl.categoryId.isValue(categoryId)))
          .get();
}
