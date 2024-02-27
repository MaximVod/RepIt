import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/favorites/data/favorites_data_source.dart';

/// Repository interface for favorites cards
abstract interface class FavoritesRepository {
  /// Get all categories
  Future<List<CardEntity>> getAllFavCards();
}

///Implementation of [FavoritesRepository]
class FavoritesRepositoryImpl implements FavoritesRepository {
  /// Date source instance of [FavoritesDataSource] for favorites cards
  final FavoritesDataSource _favoritesDataSource;

  /// Constructor for repository
  FavoritesRepositoryImpl(this._favoritesDataSource);

  @override
  Future<List<CardEntity>> getAllFavCards() async {
    final cardsList = await _favoritesDataSource.getAllFavCards();
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
}
