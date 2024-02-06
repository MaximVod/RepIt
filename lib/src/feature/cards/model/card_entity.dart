// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_entity.freezed.dart';

/// Entity for cards category
@freezed
class CardEntity with _$CardEntity {
  const factory CardEntity({
    required int id,
    required String key,
    required String value,
  }) = _CardEntity;
}