// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  destinations: (json['destinations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  status: $enumDecode(_$TripStatusEnumMap, json['status']),
  budget: (json['budget'] as num).toDouble(),
  currency: json['currency'] as String,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  coverImage: json['coverImage'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'description': instance.description,
  'destinations': instance.destinations,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'status': _$TripStatusEnumMap[instance.status]!,
  'budget': instance.budget,
  'currency': instance.currency,
  'participants': instance.participants,
  'coverImage': instance.coverImage,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$TripStatusEnumMap = {
  TripStatus.planning: 'planning',
  TripStatus.ongoing: 'ongoing',
  TripStatus.completed: 'completed',
  TripStatus.cancelled: 'cancelled',
};
