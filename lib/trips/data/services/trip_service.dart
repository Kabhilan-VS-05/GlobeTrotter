import 'dart:async';
import '../models/trip_model.dart';

class TripService {
  static final TripService _instance = TripService._internal();
  factory TripService() => _instance;
  TripService._internal();

  final List<TripModel> _trips = [];
  final _tripsController = StreamController<List<TripModel>>.broadcast();

  Stream<List<TripModel>> get tripsStream => _tripsController.stream;
  List<TripModel> get allTrips => List.unmodifiable(_trips);

  // Add sample trips for demonstration
  void initializeSampleTrips() {
    if (_trips.isEmpty) {
      _trips.addAll([
        TripModel(
          id: '1',
          userId: 'demo-user',
          title: 'Paris Adventure',
          description: 'A romantic trip to the City of Light with visits to the Eiffel Tower, Louvre Museum, and charming cafes.',
          destinations: ['Paris, France'],
          startDate: DateTime.now().add(Duration(days: 30)),
          endDate: DateTime.now().add(Duration(days: 35)),
          status: TripStatus.planning,
          budget: 2500.0,
          currency: 'USD',
          participants: ['John Doe', 'Jane Smith'],
          coverImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tour_Eiffel_Wikimedia_Commons.jpg/1600px-Tour_Eiffel_Wikimedia_Commons.jpg',
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
        ),
        TripModel(
          id: '2',
          userId: 'demo-user',
          title: 'Tokyo Discovery',
          description: 'Explore the vibrant culture of Tokyo, from ancient temples to modern technology.',
          destinations: ['Tokyo, Japan'],
          startDate: DateTime.now().add(Duration(days: 60)),
          endDate: DateTime.now().add(Duration(days: 67)),
          status: TripStatus.planning,
          budget: 3200.0,
          currency: 'USD',
          participants: ['John Doe'],
          coverImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Tokyo_Skytree_2012_May.JPG/1600px-Tokyo_Skytree_2012_May.JPG',
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        TripModel(
          id: '3',
          userId: 'demo-user',
          title: 'Bali Retreat',
          description: 'Relaxing beach vacation with temple visits and cultural experiences.',
          destinations: ['Bali, Indonesia'],
          startDate: DateTime.now().subtract(Duration(days: 10)),
          endDate: DateTime.now().subtract(Duration(days: 3)),
          status: TripStatus.completed,
          budget: 1800.0,
          currency: 'USD',
          participants: ['John Doe', 'Mike Johnson', 'Sarah Williams'],
          coverImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Tanah_Lot_temple_Bali.jpg/1600px-Tanah_Lot_temple_Bali.jpg',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          updatedAt: DateTime.now().subtract(Duration(days: 3)),
        ),
      ]);
      _tripsController.add(List.from(_trips));
    }
  }

  List<TripModel> getTripsByStatus(TripStatus status) {
    return _trips.where((trip) => trip.status == status).toList();
  }

  List<TripModel> getUpcomingTrips() {
    return _trips.where((trip) => trip.isUpcoming).toList();
  }

  List<TripModel> getOngoingTrips() {
    return _trips.where((trip) => trip.isOngoing).toList();
  }

  List<TripModel> getCompletedTrips() {
    return _trips.where((trip) => trip.isCompleted).toList();
  }

  Future<void> addTrip(TripModel trip) async {
    _trips.add(trip);
    _tripsController.add(List.from(_trips));
  }

  Future<void> updateTrip(TripModel trip) async {
    final index = _trips.indexWhere((t) => t.id == trip.id);
    if (index != -1) {
      _trips[index] = trip;
      _tripsController.add(List.from(_trips));
    }
  }

  Future<void> deleteTrip(String tripId) async {
    _trips.removeWhere((trip) => trip.id == tripId);
    _tripsController.add(List.from(_trips));
  }

  void dispose() {
    _tripsController.close();
  }
}
