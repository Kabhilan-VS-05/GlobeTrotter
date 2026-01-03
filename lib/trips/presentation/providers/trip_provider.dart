import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/trip_model.dart';
import '../../data/repositories/trip_repository.dart';

enum TripStatusFilter {
  all,
  upcoming,
  ongoing,
  completed,
}

class TripState {
  final bool isLoading;
  final List<TripModel> trips;
  final TripModel? currentTrip;
  final String? errorMessage;
  final TripStatusFilter statusFilter;

  const TripState({
    this.isLoading = false,
    this.trips = const [],
    this.currentTrip,
    this.errorMessage,
    this.statusFilter = TripStatusFilter.all,
  });

  TripState copyWith({
    bool? isLoading,
    List<TripModel>? trips,
    TripModel? currentTrip,
    String? errorMessage,
    TripStatusFilter? statusFilter,
  }) {
    return TripState(
      isLoading: isLoading ?? this.isLoading,
      trips: trips ?? this.trips,
      currentTrip: currentTrip ?? this.currentTrip,
      errorMessage: errorMessage ?? this.errorMessage,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  List<TripModel> get filteredTrips {
    switch (statusFilter) {
      case TripStatusFilter.upcoming:
        return trips.where((trip) => trip.isUpcoming).toList();
      case TripStatusFilter.ongoing:
        return trips.where((trip) => trip.isOngoing).toList();
      case TripStatusFilter.completed:
        return trips.where((trip) => trip.isCompleted).toList();
      case TripStatusFilter.all:
      default:
        return trips;
    }
  }

  double get totalBudget {
    return trips.fold(0.0, (sum, trip) => sum + trip.budget);
  }

  int get tripCount => trips.length;
}

class TripNotifier extends StateNotifier<TripState> {
  final TripRepository _repository;

  TripNotifier(this._repository) : super(const TripState());

  Future<void> loadTrips(String userId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final trips = await _repository.getUserTrips(userId);
      
      state = state.copyWith(
        isLoading: false,
        trips: trips,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createTrip(TripModel trip) async {
    state = state.copyWith(isLoading: true);
    
    try {
      final createdTrip = await _repository.createTrip(trip);
      final updatedTrips = [...state.trips, createdTrip];
      
      state = state.copyWith(
        isLoading: false,
        trips: updatedTrips,
        currentTrip: createdTrip,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _repository.updateTrip(trip);
      final updatedTrips = state.trips.map((t) => t.id == trip.id ? trip : t).toList();
      
      state = state.copyWith(
        isLoading: false,
        trips: updatedTrips,
        currentTrip: state.currentTrip?.id == trip.id ? trip : state.currentTrip,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteTrip(String tripId) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _repository.deleteTrip(tripId);
      final updatedTrips = state.trips.where((t) => t.id != tripId).toList();
      
      state = state.copyWith(
        isLoading: false,
        trips: updatedTrips,
        currentTrip: state.currentTrip?.id == tripId ? null : state.currentTrip,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setCurrentTrip(TripModel? trip) {
    state = state.copyWith(currentTrip: trip);
  }

  void setStatusFilter(TripStatusFilter filter) {
    state = state.copyWith(statusFilter: filter);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return FirestoreTripRepository();
});

final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  return TripNotifier(ref.read(tripRepositoryProvider));
});
