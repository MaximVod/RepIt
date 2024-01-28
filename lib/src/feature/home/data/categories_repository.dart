import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/feature/home/data/categories_date_source.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

/// Repository interface for cards categories
abstract interface class CategoriesRepository {
  /// Get all categories
  Future<List<CategoryEntity>> getAllCategories();

  /// Add category to db
  Future<void> addCategory(String categoryName);
}

/// Implementation of CategoriesRepository
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesDataSource categoriesDataSource;

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
}
