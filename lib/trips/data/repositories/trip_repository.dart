import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';

abstract class TripRepository {
  Future<List<TripModel>> getUserTrips(String userId);
  Future<TripModel> getTripById(String tripId);
  Future<TripModel> createTrip(TripModel trip);
  Future<TripModel> updateTrip(TripModel trip);
  Future<void> deleteTrip(String tripId);
  Stream<List<TripModel>> watchUserTrips(String userId);
  Stream<TripModel> watchTrip(String tripId);
}

class FirestoreTripRepository implements TripRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<TripModel>> getUserTrips(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data()!;
            data['id'] = doc.id;
            return TripModel.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to get user trips: $e');
    }
  }

  @override
  Future<TripModel> getTripById(String tripId) async {
    try {
      final doc = await _firestore.collection('trips').doc(tripId).get();
      
      if (!doc.exists) {
        throw Exception('Trip not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      return TripModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get trip: $e');
    }
  }

  @override
  Future<TripModel> createTrip(TripModel trip) async {
    try {
      final docRef = await _firestore.collection('trips').add(trip.toJson());
      
      final createdTrip = trip.copyWith(id: docRef.id);
      await docRef.update(createdTrip.toJson());
      
      return createdTrip;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }

  @override
  Future<TripModel> updateTrip(TripModel trip) async {
    try {
      await _firestore.collection('trips').doc(trip.id).update(trip.toJson());
      return trip;
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    try {
      await _firestore.collection('trips').doc(tripId).delete();
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }

  @override
  Stream<List<TripModel>> watchUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripModel.fromJson(doc.data()!..['id'] = doc.id))
            .toList());
  }

  @override
  Stream<TripModel> watchTrip(String tripId) {
    return _firestore
        .collection('trips')
        .doc(tripId)
        .snapshots()
        .map((doc) => TripModel.fromJson(doc.data()!..['id'] = doc.id));
  }
}
