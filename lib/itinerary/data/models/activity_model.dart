import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

enum ActivityType {
  @JsonValue('transportation')
  transportation,
  @JsonValue('accommodation')
  accommodation,
  @JsonValue('dining')
  dining,
  @JsonValue('sightseeing')
  sightseeing,
  @JsonValue('entertainment')
  entertainment,
  @JsonValue('shopping')
  shopping,
  @JsonValue('other')
  other,
}

enum ActivityStatus {
  @JsonValue('planned')
  planned,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@JsonSerializable()
class ActivityModel extends Equatable {
  final String id;
  final String itinerarySectionId;
  final String title;
  final String description;
  final ActivityType type;
  final ActivityStatus status;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final double cost;
  final String currency;
  final List<String> attachments;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityModel({
    required this.id,
    required this.itinerarySectionId,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.cost,
    required this.currency,
    this.attachments = const [],
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  ActivityModel copyWith({
    String? id,
    String? itinerarySectionId,
    String? title,
    String? description,
    ActivityType? type,
    ActivityStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    double? cost,
    String? currency,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      itinerarySectionId: itinerarySectionId ?? this.itinerarySectionId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration => endTime.difference(startTime);
  bool get isAllDay => startTime.hour == 0 && endTime.hour == 23 && endTime.minute == 59;

  @override
  List<Object?> get props => [
        id,
        itinerarySectionId,
        title,
        description,
        type,
        status,
        startTime,
        endTime,
        location,
        cost,
        currency,
        attachments,
        metadata,
        createdAt,
        updatedAt,
      ];
}
