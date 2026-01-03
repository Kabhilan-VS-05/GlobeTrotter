import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary_section_model.g.dart';

@JsonSerializable()
class ItinerarySectionModel extends Equatable {
  final String id;
  final String tripId;
  final String title;
  final String description;
  final DateTime date;
  final List<String> activityIds;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItinerarySectionModel({
    required this.id,
    required this.tripId,
    required this.title,
    required this.description,
    required this.date,
    this.activityIds = const [],
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItinerarySectionModel.fromJson(Map<String, dynamic> json) =>
      _$ItinerarySectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItinerarySectionModelToJson(this);

  ItinerarySectionModel copyWith({
    String? id,
    String? tripId,
    String? title,
    String? description,
    DateTime? date,
    List<String>? activityIds,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItinerarySectionModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      activityIds: activityIds ?? this.activityIds,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        title,
        description,
        date,
        activityIds,
        order,
        createdAt,
        updatedAt,
      ];
}
