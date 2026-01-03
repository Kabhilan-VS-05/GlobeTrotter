// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItinerarySectionModel _$ItinerarySectionModelFromJson(
  Map<String, dynamic> json,
) => ItinerarySectionModel(
  id: json['id'] as String,
  tripId: json['tripId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  activityIds:
      (json['activityIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  order: (json['order'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ItinerarySectionModelToJson(
  ItinerarySectionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'tripId': instance.tripId,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'activityIds': instance.activityIds,
  'order': instance.order,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
