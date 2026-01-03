import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_model.g.dart';

enum TripStatus {
  @JsonValue('planning')
  planning,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@JsonSerializable()
class TripModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> destinations;
  final DateTime startDate;
  final DateTime endDate;
  final TripStatus status;
  final double budget;
  final String currency;
  final List<String> participants;
  final String? coverImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TripModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.destinations,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.budget,
    required this.currency,
    this.participants = const [],
    this.coverImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);

  Map<String, dynamic> toJson() => _$TripModelToJson(this);

  TripModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<String>? destinations,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
    double? budget,
    String? currency,
    List<String>? participants,
    String? coverImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      destinations: destinations ?? this.destinations,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      participants: participants ?? this.participants,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isOngoing => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isCompleted => DateTime.now().isAfter(endDate);

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        destinations,
        startDate,
        endDate,
        status,
        budget,
        currency,
        participants,
        coverImage,
        createdAt,
        updatedAt,
      ];
}
