// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: json['id'] as String,
      itinerarySectionId: json['itinerarySectionId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      status: $enumDecode(_$ActivityStatusEnumMap, json['status']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String?,
      cost: (json['cost'] as num).toDouble(),
      currency: json['currency'] as String,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itinerarySectionId': instance.itinerarySectionId,
      'title': instance.title,
      'description': instance.description,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'status': _$ActivityStatusEnumMap[instance.status]!,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
      'cost': instance.cost,
      'currency': instance.currency,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.transportation: 'transportation',
  ActivityType.accommodation: 'accommodation',
  ActivityType.dining: 'dining',
  ActivityType.sightseeing: 'sightseeing',
  ActivityType.entertainment: 'entertainment',
  ActivityType.shopping: 'shopping',
  ActivityType.other: 'other',
};

const _$ActivityStatusEnumMap = {
  ActivityStatus.planned: 'planned',
  ActivityStatus.inProgress: 'in_progress',
  ActivityStatus.completed: 'completed',
  ActivityStatus.cancelled: 'cancelled',
};
