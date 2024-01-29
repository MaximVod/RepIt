import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repit/src/core/components/database/src/app_database.dart';
import 'package:repit/src/feature/home/data/categories_date_source.dart';
import 'package:repit/src/feature/home/data/categories_repository.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

void main() {
  late AppDatabase database;
  late CategoriesDataSource dataSource;
  late CategoriesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dataSource = CategoriesDao(database);
    repository = CategoriesRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await database.close();
  });

  group('Test for Categories', () {
    test('Get all categories test', () async {
      final list = await repository.getAllCategories();
      expect(list, isA<List<CategoryEntity>>());
    });

    test('Create category test', () async {
      const String firstCategory = "firstCategory";
      const String secondCategory = "secondCategory";
      await repository.addCategory(firstCategory);
      await repository.addCategory(secondCategory);
      final list = await repository.getAllCategories();
      final category = list.any((element) => element.name == firstCategory);
      final firstId = list.first.id;
      final secondId = list[1].id;
      expect(category, true);
      expect(secondId > firstId, true);
    });

    test('Remove category test', () async {
      const String firstCategory = "firstCategory";
      const String secondCategory = "secondCategory";
      await repository.addCategory(firstCategory);
      await repository.addCategory(secondCategory);
      final list = await repository.getAllCategories();
      await repository.removeCategory(list[1]);
      final newList = await repository.getAllCategories();
      expect(newList.length, 1);
    });

    test('Edit category test', () async {
      const String firstCategory = "firstCategory";
      const String newCategoryName = "newCategoryName";
      await repository.addCategory(firstCategory);
      final list = await repository.getAllCategories();
      await repository.updateCategory(list[0], newCategoryName);
      final newList = await repository.getAllCategories();
      expect(newList.length, 1);
      expect(newList.first.name != firstCategory, true);
    });
  });
}
