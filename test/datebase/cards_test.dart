import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/feature/cards/data/cards_data_source.dart';
import 'package:repit/src/feature/cards/data/cards_repository.dart';
import 'package:repit/src/feature/cards/model/card_entity.dart';

void main() {
  late AppDatabase database;
  late CardsDataSource dataSource;
  late CardsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = CardsDao(database);
    repository = CardsRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await database.close();
  });

  group("Cards fetching from db tests", () {
    test('Create and fetching cards test', () async {
      await repository.addCard(
        const CardEntity(
          id: 1,
          key: "First",
          value: "Первый",
          categoryId: 2,
        ),
      );
      await repository.addCard(
        const CardEntity(
          id: 2,
          key: "Second",
          value: "Второй",
          categoryId: 2,
        ),
      );
      final list = await repository.getCardsById(2);
      expect(list.length == 2, true);
      expect(list.any((element) => element.key == "Second"), true);
    });

    test('Delete cards from db test', () async {
      const card = CardEntity(
        id: 1,
        key: "First",
        value: "Первый",
        categoryId: 2,
      );
      await repository.addCard(
          card,
      );
      final list = await repository.getCardsById(2);
      expect(list.length == 1, true);
      await repository.removeCard(
          1,
      );
      final refreshList = await repository.getCardsById(2);
      expect(refreshList.isEmpty, true);
    });

    test('Set card is favorite test', () async {
      const card = CardEntity(
        id: 1,
        key: "First",
        value: "Первый",
        categoryId: 2,
      );
      await repository.addCard(
        card,
      );
      var list = await repository.getCardsById(2);
      expect(list.length == 1, true);
      expect(list[0].isFavorite, false);
      await repository.setFavoriteCard(1, isFavorite: true);
      list = await repository.getCardsById(2);
      expect(list[0].isFavorite, true);
      await repository.setFavoriteCard(1, isFavorite: false);
      list = await repository.getCardsById(2);
      expect(list[0].isFavorite, false);
    });
  });
}
