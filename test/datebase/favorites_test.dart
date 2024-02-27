import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repit/src/core/components/database/src/app_database.dart';
import 'package:repit/src/feature/cards/data/cards_data_source.dart';
import 'package:repit/src/feature/cards/data/cards_repository.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';
import 'package:repit/src/feature/favorites/data/favorites_data_source.dart';
import 'package:repit/src/feature/favorites/data/favorites_repository.dart';

void main() {
  late AppDatabase database;
  late CardsDataSource cardsDataSource;
  late FavoritesDataSource favDataSource;
  late CardsRepository cardsRepository;
  late FavoritesRepository favRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    cardsDataSource = CardsDao(database);
    favDataSource = FavDao(database);
    cardsRepository = CardsRepositoryImpl(cardsDataSource);
    favRepository = FavoritesRepositoryImpl(favDataSource);
  });

  tearDown(() async {
    await database.close();
  });

  group("Favorite cards fetching from db tests", () {
    test('Create and fetching favorite cards test', () async {
      await cardsRepository.addCard(
        const CardEntity(
          id: 1,
          key: "First",
          value: "Первый",
          categoryId: 1,
        ),
      );
      await cardsRepository.addCard(
        const CardEntity(
          id: 2,
          key: "Second",
          value: "Второй",
          categoryId: 2,
        ),
      );
      var favList = await favRepository.getAllFavCards();
      expect(favList.isEmpty, true);
      await cardsRepository.setFavoriteCard(1, isFavorite: true);
      await cardsRepository.setFavoriteCard(2, isFavorite: true);
      favList = await favRepository.getAllFavCards();
      expect(favList.length == 2, true);
    });
  });
}
