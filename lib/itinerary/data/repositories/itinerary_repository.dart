import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/itinerary_section_model.dart';
import '../models/activity_model.dart';

abstract class ItineraryRepository {
  // Itinerary Sections
  Future<List<ItinerarySectionModel>> getSectionsByTrip(String tripId);
  Future<ItinerarySectionModel> createSection(ItinerarySectionModel section);
  Future<ItinerarySectionModel> updateSection(ItinerarySectionModel section);
  Future<void> deleteSection(String sectionId);

  // Activities
  Future<List<ActivityModel>> getActivitiesBySection(String sectionId);
  Future<ActivityModel> createActivity(ActivityModel activity);
  Future<ActivityModel> updateActivity(ActivityModel activity);
  Future<void> deleteActivity(String activityId);

  // Streams
  Stream<List<ItinerarySectionModel>> watchSectionsByTrip(String tripId);
  Stream<List<ActivityModel>> watchActivitiesBySection(String sectionId);
}

class FirestoreItineraryRepository implements ItineraryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Itinerary Sections
  @override
  Future<List<ItinerarySectionModel>> getSectionsByTrip(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('itinerary_sections')
          .where('tripId', isEqualTo: tripId)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => ItinerarySectionModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sections: $e');
    }
  }

  @override
  Future<ItinerarySectionModel> createSection(ItinerarySectionModel section) async {
    try {
      final docRef = await _firestore.collection('itinerary_sections').add(section.toJson());
      
      final createdSection = section.copyWith(id: docRef.id);
      await docRef.update(createdSection.toJson());
      
      return createdSection;
    } catch (e) {
      throw Exception('Failed to create section: $e');
    }
  }

  @override
  Future<ItinerarySectionModel> updateSection(ItinerarySectionModel section) async {
    try {
      await _firestore.collection('itinerary_sections').doc(section.id).update(section.toJson());
      return section;
    } catch (e) {
      throw Exception('Failed to update section: $e');
    }
  }

  @override
  Future<void> deleteSection(String sectionId) async {
    try {
      // Delete section and all its activities
      final batch = _firestore.batch();
      
      // Delete the section
      batch.delete(_firestore.collection('itinerary_sections').doc(sectionId));
      
      // Delete all activities in this section
      final activitiesSnapshot = await _firestore
          .collection('activities')
          .where('itinerarySectionId', isEqualTo: sectionId)
          .get();
      
      for (final doc in activitiesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete section: $e');
    }
  }

  // Activities
  @override
  Future<List<ActivityModel>> getActivitiesBySection(String sectionId) async {
    try {
      final snapshot = await _firestore
          .collection('activities')
          .where('itinerarySectionId', isEqualTo: sectionId)
          .orderBy('startTime')
          .get();

      return snapshot.docs
          .map((doc) => ActivityModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get activities: $e');
    }
  }

  @override
  Future<ActivityModel> createActivity(ActivityModel activity) async {
    try {
      final docRef = await _firestore.collection('activities').add(activity.toJson());
      
      final createdActivity = activity.copyWith(id: docRef.id);
      await docRef.update(createdActivity.toJson());
      
      return createdActivity;
    } catch (e) {
      throw Exception('Failed to create activity: $e');
    }
  }

  @override
  Future<ActivityModel> updateActivity(ActivityModel activity) async {
    try {
      await _firestore.collection('activities').doc(activity.id).update(activity.toJson());
      return activity;
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  @override
  Future<void> deleteActivity(String activityId) async {
    try {
      await _firestore.collection('activities').doc(activityId).delete();
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  // Streams
  @override
  Stream<List<ItinerarySectionModel>> watchSectionsByTrip(String tripId) {
    return _firestore
        .collection('itinerary_sections')
        .where('tripId', isEqualTo: tripId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ItinerarySectionModel.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }

  @override
  Stream<List<ActivityModel>> watchActivitiesBySection(String sectionId) {
    return _firestore
        .collection('activities')
        .where('itinerarySectionId', isEqualTo: sectionId)
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }
}
