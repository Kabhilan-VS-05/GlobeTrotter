// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
  id: json['id'] as String,
  tripId: json['tripId'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$BudgetCategoryEnumMap, json['category']),
  allocatedAmount: (json['allocatedAmount'] as num).toDouble(),
  spentAmount: (json['spentAmount'] as num).toDouble(),
  currency: json['currency'] as String,
  activityIds:
      (json['activityIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'name': instance.name,
      'category': _$BudgetCategoryEnumMap[instance.category]!,
      'allocatedAmount': instance.allocatedAmount,
      'spentAmount': instance.spentAmount,
      'currency': instance.currency,
      'activityIds': instance.activityIds,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BudgetCategoryEnumMap = {
  BudgetCategory.transportation: 'transportation',
  BudgetCategory.accommodation: 'accommodation',
  BudgetCategory.dining: 'dining',
  BudgetCategory.entertainment: 'entertainment',
  BudgetCategory.shopping: 'shopping',
  BudgetCategory.activities: 'activities',
  BudgetCategory.other: 'other',
};
