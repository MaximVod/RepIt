import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/components/database/src/tables/cards.dart';

part 'favorites_data_source.g.dart';

/// Interface for favorite cards data source
abstract interface class FavoritesDataSource {
  /// Get all categories
  Future<List<Card>> getAllFavCards();
}

/// DAO for favorites cards
@DriftAccessor(tables: [Cards])
class FavDao extends DatabaseAccessor<AppDatabase>
    with _$FavDaoMixin
    implements FavoritesDataSource {
  /// Favorites DAO constructor
  FavDao(super.attachedDatabase);

  @override
  Future<List<Card>> getAllFavCards() => (select(attachedDatabase.cards)
        ..where((tbl) => tbl.isFavorite.isValue(true)))
      .get();
}
