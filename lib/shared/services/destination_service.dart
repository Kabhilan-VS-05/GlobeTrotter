export '../data/destinations_data.dart' show Destination;

import 'package:flutter/material.dart';
import '../services/location_api_service.dart';
import '../data/destinations_data.dart';

class DestinationService {
  static final DestinationService _instance = DestinationService._internal();
  factory DestinationService() => _instance;
  DestinationService._internal();

  final LocationApiService _locationApi = LocationApiService();
  List<Destination> _destinations = [];

  Future<void> initializeDestinations() async {
    if (_destinations.isEmpty) {
      // Initialize locations and fetch details from APIs
      await _locationApi.initializeLocations();
      
      // Create destinations from API location data
      _destinations = await _createDestinationsFromApiData();
    }
  }

  Future<List<Destination>> _createDestinationsFromApiData() async {
    final List<Destination> destinations = [];
    final locations = _locationApi.allLocations;

    for (var location in locations) {
      // Create destination from API location data
      final destination = _convertLocationToDestination(location);
      destinations.add(destination);
    }

    return destinations;
  }

  Destination _convertLocationToDestination(Location location) {
    return Destination(
      id: location.id,
      name: location.name,
      country: location.country,
      description: _generateDescription(location),
      imageUrl: location.imageUrl,
      rating: _generateRating(location),
      reviewCount: _generateReviewCount(location),
      price: _generatePrice(location),
      activities: location.activities.isNotEmpty ? location.activities : _generateDefaultActivities(location),
      category: _generateCategory(location),
      themeColor: _generateThemeColor(location),
      highlights: _generateHighlights(location),
      bestTimeToVisit: location.bestTimeToVisit.isNotEmpty ? location.bestTimeToVisit : _generateBestTimeToVisit(location),
      averageStay: _generateAverageStay(location),
      locationData: location,
    );
  }

  String _generateDescription(Location location) {
    if (location.description.isNotEmpty && !location.description.contains('API')) {
      return location.description;
    }
    
    // Generate description based on location data
    final baseDesc = _getBaseDescription(location);
    final climateInfo = location.climate.isNotEmpty ? 
        'Experience ${location.climate.toLowerCase()} climate in this ${location.region.toLowerCase()} destination.' : '';
    final attractionInfo = location.attractions.isNotEmpty ? 
        'Known for ${location.attractions.take(2).join(' and ')}.' : '';
    
    return '$baseDesc $climateInfo $attractionInfo'.trim();
  }

  String _getBaseDescription(Location location) {
    final descriptions = {
      'paris-france': 'The City of Light awaits with iconic landmarks, world-class museums, and exquisite cuisine.',
      'tokyo-japan': 'A mesmerizing blend of ancient traditions and cutting-edge technology in the world\'s most populous metropolis.',
      'bali-indonesia': 'Tropical paradise with stunning beaches, ancient temples, and lush rice terraces.',
      'newyork-usa': 'The city that never sleeps offers endless entertainment, world-class museums, and iconic skyline.',
      'dubai-uae': 'Futuristic city with record-breaking architecture, luxury shopping, and desert adventures.',
      'rome-italy': 'Eternal City where ancient ruins, Renaissance art, and vibrant street life create an unforgettable experience.',
      'santorini-greece': 'Stunning sunsets, white-washed buildings, and crystal-clear waters in the Aegean Sea.',
    };
    
    return descriptions[location.id] ?? 
        'Discover the charm of ${location.name}, a beautiful destination in ${location.country} with unique experiences waiting for you.';
  }

  double _generateRating(Location location) {
    // Generate rating based on location features
    double baseRating = 4.0;
    
    if (location.population > 1000000) baseRating += 0.3; // Major cities
    if (location.attractions.length >= 4) baseRating += 0.2; // Many attractions
    if (location.activities.length >= 4) baseRating += 0.2; // Many activities
    if (location.region == 'Europe') baseRating += 0.1; // Popular destinations
    
    return baseRating.clamp(3.5, 5.0);
  }

  int _generateReviewCount(Location location) {
    // Generate realistic review count based on population
    if (location.population > 5000000) return (15000 + (location.population ~/ 1000));
    if (location.population > 1000000) return (8000 + (location.population ~/ 2000));
    if (location.population > 100000) return (3000 + (location.population ~/ 5000));
    return (500 + (location.population ~/ 10000));
  }

  double _generatePrice(Location location) {
    // Generate price based on location and region
    final basePrices = {
      'Europe': 2500.0,
      'Asia': 2000.0,
      'Americas': 3000.0,
      'Oceania': 3500.0,
      'Africa': 1800.0,
    };
    
    double basePrice = basePrices[location.region] ?? 2000.0;
    
    // Adjust based on population (major cities are more expensive)
    if (location.population > 5000000) basePrice *= 1.3;
    if (location.population > 1000000) basePrice *= 1.1;
    
    return basePrice;
  }

  List<String> _generateDefaultActivities(Location location) {
    final activities = <String>[];
    
    // Add activities based on location features
    if (location.climate.toLowerCase().contains('tropical') || location.climate.toLowerCase().contains('warm')) {
      activities.addAll(['Beach activities', 'Water sports', 'Outdoor exploration']);
    }
    
    if (location.population > 1000000) {
      activities.addAll(['City tours', 'Museum visits', 'Shopping']);
    }
    
    if (location.attractions.isNotEmpty) {
      activities.add('Sightseeing');
    }
    
    // Add regional activities
    switch (location.region) {
      case 'Europe':
        activities.addAll(['Historical tours', 'Cultural experiences']);
        break;
      case 'Asia':
        activities.addAll(['Temple visits', 'Local cuisine']);
        break;
      case 'Americas':
        activities.addAll(['Adventure activities', 'Nature exploration']);
        break;
      default:
        activities.add('Local experiences');
    }
    
    return activities.take(4).toList();
  }

  String _generateCategory(Location location) {
    // Determine category based on location characteristics
    if (location.climate.toLowerCase().contains('tropical') || 
        location.climate.toLowerCase().contains('warm')) {
      return 'Beach';
    }
    
    if (location.population > 2000000) {
      return 'Urban';
    }
    
    if (location.attractions.any((attr) => 
        attr.toLowerCase().contains('temple') || 
        attr.toLowerCase().contains('church') || 
        attr.toLowerCase().contains('museum'))) {
      return 'Cultural';
    }
    
    if (location.activities.any((activity) => 
        activity.toLowerCase().contains('safari') || 
        activity.toLowerCase().contains('hiking') || 
        activity.toLowerCase().contains('diving'))) {
      return 'Adventure';
    }
    
    return 'General';
  }

  Color _generateThemeColor(Location location) {
    // Generate theme color based on region and characteristics
    final regionColors = {
      'Europe': const Color(0xFFE8B4B8), // Light pink
      'Asia': const Color(0xFFB8E8B8), // Light green
      'Americas': const Color(0xFFE8E8B8), // Light yellow
      'Oceania': const Color(0xFF87CEEB), // Sky blue
      'Africa': const Color(0xFFE8B8D8), // Light purple
    };
    
    Color baseColor = regionColors[location.region] ?? const Color(0xFFE8E8E8);
    
    // Adjust based on climate
    if (location.climate.toLowerCase().contains('tropical')) {
      return const Color(0xFF87CEEB); // Blue for tropical
    }
    
    return baseColor;
  }

  List<String> _generateHighlights(Location location) {
    final highlights = <String>[];
    
    // Add highlights based on location data
    if (location.population > 1000000) {
      highlights.add('Major city');
    }
    
    if (location.attractions.isNotEmpty) {
      highlights.add('Iconic landmarks');
    }
    
    if (location.climate.toLowerCase().contains('tropical')) {
      highlights.add('Tropical paradise');
    } else if (location.climate.toLowerCase().contains('temperate')) {
      highlights.add('Pleasant climate');
    }
    
    if (location.activities.length >= 4) {
      highlights.add('Variety of activities');
    }
    
    // Add regional highlights
    switch (location.region) {
      case 'Europe':
        highlights.add('Rich history');
        break;
      case 'Asia':
        highlights.add('Unique culture');
        break;
      case 'Americas':
        highlights.add('Diverse landscapes');
        break;
    }
    
    return highlights.take(4).toList();
  }

  String _generateBestTimeToVisit(Location location) {
    if (location.bestTimeToVisit.isNotEmpty && !location.bestTimeToVisit.contains('Year-round')) {
      return location.bestTimeToVisit;
    }
    
    // Generate best time based on climate
    switch (location.climate.toLowerCase()) {
      case 'tropical':
        return 'November - April (dry season)';
      case 'temperate':
        return 'April - June, September - October';
      case 'warm':
        return 'October - April';
      case 'cold':
        return 'June - August';
      default:
        return 'Year-round';
    }
  }

  Duration _generateAverageStay(Location location) {
    // Generate stay duration based on location size and activities
    if (location.population > 5000000) return const Duration(days: 5);
    if (location.population > 1000000) return const Duration(days: 4);
    if (location.activities.length >= 4) return const Duration(days: 6);
    return const Duration(days: 3);
  }

  // Search destinations using API
  Future<List<Destination>> searchDestinations(String query) async {
    // First try to find in existing destinations
    final existingResults = _destinations.where((dest) =>
        dest.name.toLowerCase().contains(query.toLowerCase()) ||
        dest.country.toLowerCase().contains(query.toLowerCase()) ||
        dest.description.toLowerCase().contains(query.toLowerCase())
    ).toList();

    if (existingResults.isNotEmpty) {
      return existingResults;
    }

    // If no existing results, search via API
    try {
      final apiLocations = await _locationApi.searchWorldwideLocations(query);
      return apiLocations.map(_convertLocationToDestination).toList();
    } catch (e) {
      print('Error searching destinations via API: $e');
      return [];
    }
  }

  // Get popular destinations from API data
  List<Destination> get popularDestinations {
    // Sort by rating and return top destinations
    final sorted = List<Destination>.from(_destinations);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(7).toList();
  }

  // Get trending destinations (recently viewed or high-rated)
  List<Destination> get trendingDestinations {
    // Return high-rated destinations with good review counts
    return _destinations.where((dest) => 
        dest.rating >= 4.7 && dest.reviewCount >= 5000
    ).take(3).toList();
  }

  List<Destination> get allDestinations => List.unmodifiable(_destinations);

  Destination? getDestinationById(String id) {
    try {
      return _destinations.firstWhere((dest) => dest.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Destination> getDestinationsByRegion(String region) {
    return _destinations.where((dest) => 
        dest.locationData?.region == region
    ).toList();
  }

  Future<Destination?> getDestinationByCoordinates(double lat, double lon) async {
    final location = await _locationApi.getLocationByCoordinates(lat, lon);
    if (location != null) {
      return getDestinationById(location.id);
    }
    return null;
  }

  Future<void> refreshDestinations() async {
    // Refresh from APIs
    await _locationApi.initializeLocations();
    _destinations = await _createDestinationsFromApiData();
  }

  // Get destination statistics from API data
  Map<String, dynamic> getDestinationStats() {
    final regions = <String, int>{};
    final categories = <String, int>{};
    
    for (var destination in _destinations) {
      final region = destination.locationData?.region ?? 'Unknown';
      regions[region] = (regions[region] ?? 0) + 1;
      
      final category = destination.category;
      categories[category] = (categories[category] ?? 0) + 1;
    }

    return {
      'totalDestinations': _destinations.length,
      'regions': regions,
      'categories': categories,
      'averageRating': _destinations.isEmpty ? 0.0 : 
          _destinations.map((d) => d.rating).reduce((a, b) => a + b) / _destinations.length,
      'totalReviews': _destinations.map((d) => d.reviewCount).reduce((a, b) => a + b),
    };
  }

  // Get recommended destinations based on preferences
  List<Destination> getRecommendedDestinations({
    String? preferredRegion,
    String? preferredClimate,
    double? maxPrice,
    List<String>? preferredActivities,
  }) {
    var destinations = List<Destination>.from(_destinations);

    if (preferredRegion != null) {
      destinations = destinations.where((d) => 
          d.locationData?.region == preferredRegion
      ).toList();
    }

    if (preferredClimate != null) {
      destinations = destinations.where((d) => 
          d.locationData?.climate.toLowerCase() == preferredClimate.toLowerCase()
      ).toList();
    }

    if (maxPrice != null) {
      destinations = destinations.where((d) => d.price <= maxPrice).toList();
    }

    if (preferredActivities != null && preferredActivities.isNotEmpty) {
      destinations = destinations.where((d) {
        return preferredActivities.any((activity) =>
            d.activities.any((destActivity) =>
                destActivity.toLowerCase().contains(activity.toLowerCase())
            )
        );
      }).toList();
    }

    // Sort by rating and return top results
    destinations.sort((a, b) => b.rating.compareTo(a.rating));
    return destinations.take(5).toList();
  }
}
