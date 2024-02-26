
// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Entity for cards category
@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required int id,
    required String name,
  }) = _CategoryEntity;
}
