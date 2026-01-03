import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/itinerary_section_model.dart';
import '../../data/models/activity_model.dart';

class ItineraryState {
  final bool isLoading;
  final List<ItinerarySectionModel> sections;
  final List<ActivityModel> activities;
  final ItinerarySectionModel? currentSection;
  final String? errorMessage;

  const ItineraryState({
    this.isLoading = false,
    this.sections = const [],
    this.activities = const [],
    this.currentSection,
    this.errorMessage,
  });

  ItineraryState copyWith({
    bool? isLoading,
    List<ItinerarySectionModel>? sections,
    List<ActivityModel>? activities,
    ItinerarySectionModel? currentSection,
    String? errorMessage,
  }) {
    return ItineraryState(
      isLoading: isLoading ?? this.isLoading,
      sections: sections ?? this.sections,
      activities: activities ?? this.activities,
      currentSection: currentSection ?? this.currentSection,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<ActivityModel> getActivitiesForSection(String sectionId) {
    return activities.where((activity) => activity.itinerarySectionId == sectionId).toList();
  }

  int get totalSections => sections.length;
  int get totalActivities => activities.length;
}

class ItineraryNotifier extends StateNotifier<ItineraryState> {
  ItineraryNotifier() : super(const ItineraryState());

  Future<void> loadItinerary(String tripId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      // TODO: Implement actual data fetching from Firebase/Repository
      // For now, using mock data
      final mockSections = <ItinerarySectionModel>[];
      final mockActivities = <ActivityModel>[];
      
      state = state.copyWith(
        isLoading: false,
        sections: mockSections,
        activities: mockActivities,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createSection(ItinerarySectionModel section) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedSections = [...state.sections, section];
      updatedSections.sort((a, b) => a.order.compareTo(b.order));
      
      state = state.copyWith(
        isLoading: false,
        sections: updatedSections,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateSection(ItinerarySectionModel section) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedSections = state.sections.map((s) => s.id == section.id ? section : s).toList();
      updatedSections.sort((a, b) => a.order.compareTo(b.order));
      
      state = state.copyWith(
        isLoading: false,
        sections: updatedSections,
        currentSection: state.currentSection?.id == section.id ? section : state.currentSection,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteSection(String sectionId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedSections = state.sections.where((s) => s.id != sectionId).toList();
      final updatedActivities = state.activities.where((a) => a.itinerarySectionId != sectionId).toList();
      
      state = state.copyWith(
        isLoading: false,
        sections: updatedSections,
        activities: updatedActivities,
        currentSection: state.currentSection?.id == sectionId ? null : state.currentSection,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createActivity(ActivityModel activity) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedActivities = [...state.activities, activity];
      
      state = state.copyWith(
        isLoading: false,
        activities: updatedActivities,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateActivity(ActivityModel activity) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedActivities = state.activities.map((a) => a.id == activity.id ? activity : a).toList();
      
      state = state.copyWith(
        isLoading: false,
        activities: updatedActivities,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteActivity(String activityId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final updatedActivities = state.activities.where((a) => a.id != activityId).toList();
      
      state = state.copyWith(
        isLoading: false,
        activities: updatedActivities,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setCurrentSection(ItinerarySectionModel? section) {
    state = state.copyWith(currentSection: section);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final itineraryProvider = StateNotifierProvider<ItineraryNotifier, ItineraryState>((ref) {
  return ItineraryNotifier();
});
