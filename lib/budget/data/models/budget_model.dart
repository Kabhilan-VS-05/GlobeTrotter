import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_model.g.dart';

enum BudgetCategory {
  @JsonValue('transportation')
  transportation,
  @JsonValue('accommodation')
  accommodation,
  @JsonValue('dining')
  dining,
  @JsonValue('entertainment')
  entertainment,
  @JsonValue('shopping')
  shopping,
  @JsonValue('activities')
  activities,
  @JsonValue('other')
  other,
}

@JsonSerializable()
class BudgetModel extends Equatable {
  final String id;
  final String tripId;
  final String name;
  final BudgetCategory category;
  final double allocatedAmount;
  final double spentAmount;
  final String currency;
  final List<String> activityIds;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.tripId,
    required this.name,
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.currency,
    this.activityIds = const [],
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  BudgetModel copyWith({
    String? id,
    String? tripId,
    String? name,
    BudgetCategory? category,
    double? allocatedAmount,
    double? spentAmount,
    String? currency,
    List<String>? activityIds,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      category: category ?? this.category,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      currency: currency ?? this.currency,
      activityIds: activityIds ?? this.activityIds,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get remainingAmount => allocatedAmount - spentAmount;
  double get utilizationPercentage => allocatedAmount > 0 ? (spentAmount / allocatedAmount) * 100 : 0;
  bool get isOverBudget => spentAmount > allocatedAmount;
  bool get isNearLimit => utilizationPercentage >= 80;

  @override
  List<Object?> get props => [
        id,
        tripId,
        name,
        category,
        allocatedAmount,
        spentAmount,
        currency,
        activityIds,
        notes,
        createdAt,
        updatedAt,
      ];
}
