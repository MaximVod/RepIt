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
  Future<void> removeCategory(int categoryId);

  /// Remove categories from db
  Future<void> removeCategories(Iterable<int> entries);

  /// Update category in db
  Future<void> updateCategory(int categoryId, String newCategoryName);
}

/// Implementation of [CategoriesRepository]
class CategoriesRepositoryImpl implements CategoriesRepository {
  /// Date source instance of [CategoriesDataSource] for cards db
  final CategoriesDataSource _categoriesDataSource;

  /// Constructor
  CategoriesRepositoryImpl(this._categoriesDataSource);

  @override
  Future<void> addCategory(String categoryName) async => _categoriesDataSource
      .addCategory(CategoriesCompanion.insert(title: categoryName));

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    final categories = await _categoriesDataSource.getAllCategories();
    return categories
        .map((dto) => CategoryEntity(id: dto.id, name: dto.title))
        .toList();
  }

  @override
  Future<void> removeCategory(int categoryId) =>
      _categoriesDataSource.removeCategory(categoryId);

  @override
  Future<void> updateCategory(int categoryId, String newCategoryName) =>
      _categoriesDataSource.editCategory(
        categoryId,
        newCategoryName,
      );

  @override
  Future<void> removeCategories(Iterable<int> entries) =>
      _categoriesDataSource.removeCategories(entries);
}
