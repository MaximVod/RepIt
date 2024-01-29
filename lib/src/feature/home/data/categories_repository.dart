import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/feature/home/data/categories_date_source.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

/// Repository interface for cards categories
abstract interface class CategoriesRepository {
  /// Get all categories
  Future<List<CategoryEntity>> getAllCategories();

  /// Add category to db
  Future<void> addCategory(String categoryName);

  /// Remove category from db
  Future<void> removeCategory(CategoryEntity entity);

  /// Update category in db
  Future<void> updateCategory(CategoryEntity entity, String newCategoryName);
}

/// Implementation of CategoriesRepository
class CategoriesRepositoryImpl implements CategoriesRepository {

  /// Date source instance
  final CategoriesDataSource categoriesDataSource;

  /// Constructor
  CategoriesRepositoryImpl(this.categoriesDataSource);

  @override
  Future<void> addCategory(String categoryName) async => categoriesDataSource
      .addCategory(CategoriesCompanion.insert(title: categoryName));

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final categories = await categoriesDataSource.getAllCategories();
    return categories
        .map((dto) => CategoryEntity(id: dto.id, name: dto.title))
        .toList();
  }

  @override
  Future<void> removeCategory(CategoryEntity entity) =>
      categoriesDataSource.removeCategory(
        CategoriesCompanion.insert(title: entity.name, id: Value(entity.id)),
      );

  @override
  Future<void> updateCategory(CategoryEntity entity, String newCategoryName) =>
      categoriesDataSource.editCategory(
        CategoriesCompanion.insert(title: entity.name, id: Value(entity.id)),
        newCategoryName,
      );
}
