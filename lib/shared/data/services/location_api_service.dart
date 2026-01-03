import 'dart:convert';
import 'package:http/http.dart' as http;

class Location {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String timezone;
  final String currency;
  final String language;
  final List<String> attractions;
  final List<String> activities;
  final String bestTimeToVisit;
  final String climate;
  final int population;
  final String region;

  Location({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.currency,
    required this.language,
    required this.attractions,
    required this.activities,
    required this.bestTimeToVisit,
    required this.climate,
    required this.population,
    required this.region,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      timezone: json['timezone'] ?? '',
      currency: json['currency'] ?? '',
      language: json['language'] ?? '',
      attractions: List<String>.from(json['attractions'] ?? []),
      activities: List<String>.from(json['activities'] ?? []),
      bestTimeToVisit: json['bestTimeToVisit'] ?? '',
      climate: json['climate'] ?? '',
      population: json['population'] ?? 0,
      region: json['region'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'currency': currency,
      'language': language,
      'attractions': attractions,
      'activities': activities,
      'bestTimeToVisit': bestTimeToVisit,
      'climate': climate,
      'population': population,
      'region': region,
    };
  }
}

class LocationApiService {
  static final LocationApiService _instance = LocationApiService._internal();
  factory LocationApiService() => _instance;
  LocationApiService._internal();

  final List<Location> _locations = [];
  final String _baseUrl = 'https://restcountries.com/v3.1';

  List<Location> get allLocations => List.unmodifiable(_locations);

  // Initialize with sample locations and fetch additional data
  Future<void> initializeLocations() async {
    if (_locations.isEmpty) {
      // Add sample locations with basic data
      await _addSampleLocations();
      
      // Fetch additional details from APIs
      await _fetchLocationDetails();
    }
  }

  Future<void> _addSampleLocations() async {
    final sampleLocations = [
      Location(
        id: 'paris-france',
        name: 'Paris',
        country: 'France',
        description: 'The City of Light is renowned for its art, fashion, gastronomy, and culture. Home to iconic landmarks like the Eiffel Tower and Louvre Museum.',
        imageUrl: 'https://picsum.photos/seed/paris-eiffel-tower-city/1600/900.jpg',
        latitude: 48.8566,
        longitude: 2.3522,
        timezone: 'Europe/Paris',
        currency: 'EUR',
        language: 'French',
        attractions: ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame Cathedral', 'Arc de Triomphe'],
        activities: ['River Seine Cruise', 'Museum Tours', 'Wine Tasting', 'Shopping at Champs-Élysées'],
        bestTimeToVisit: 'April - June, September - October',
        climate: 'Temperate oceanic',
        population: 2148000,
        region: 'Europe',
      ),
      Location(
        id: 'tokyo-japan',
        name: 'Tokyo',
        country: 'Japan',
        description: 'A mesmerizing blend of ancient traditions and cutting-edge technology, offering everything from historic temples to futuristic skyscrapers.',
        imageUrl: 'https://picsum.photos/seed/tokyo-skyline-japan-city/1600/900.jpg',
        latitude: 35.6762,
        longitude: 139.6503,
        timezone: 'Asia/Tokyo',
        currency: 'JPY',
        language: 'Japanese',
        attractions: ['Tokyo Skytree', 'Senso-ji Temple', 'Meiji Shrine', 'Tokyo Tower'],
        activities: ['Sushi Making Classes', 'Karaoke', 'Shopping in Shibuya', 'Cherry Blossom Viewing'],
        bestTimeToVisit: 'March - May, October - November',
        climate: 'Humid subtropical',
        population: 13960000,
        region: 'Asia',
      ),
      Location(
        id: 'bali-indonesia',
        name: 'Bali',
        country: 'Indonesia',
        description: 'Tropical paradise known for its forested volcanic mountains, iconic rice paddies, beaches, and coral reefs.',
        imageUrl: 'https://picsum.photos/seed/bali-beach-tropical-indonesia/1600/900.jpg',
        latitude: -8.3405,
        longitude: 115.0920,
        timezone: 'Asia/Makassar',
        currency: 'IDR',
        language: 'Indonesian',
        attractions: ['Tanah Lot Temple', 'Ubud Rice Terraces', 'Mount Batur', 'Uluwatu Temple'],
        activities: ['Surfing', 'Temple Tours', 'Yoga Retreats', 'Traditional Dance Shows'],
        bestTimeToVisit: 'April - October',
        climate: 'Tropical',
        population: 4317000,
        region: 'Asia',
      ),
      Location(
        id: 'newyork-usa',
        name: 'New York City',
        country: 'United States',
        description: 'The city that never sleeps offers endless entertainment, world-class museums, and iconic skyline views.',
        imageUrl: 'https://picsum.photos/seed/newyork-manhattan-skyline-usa/1600/900.jpg',
        latitude: 40.7128,
        longitude: -74.0060,
        timezone: 'America/New_York',
        currency: 'USD',
        language: 'English',
        attractions: ['Statue of Liberty', 'Central Park', 'Empire State Building', 'Times Square'],
        activities: ['Broadway Shows', 'Museum Visits', 'Shopping', 'Food Tours'],
        bestTimeToVisit: 'April - June, September - November',
        climate: 'Humid subtropical',
        population: 8336000,
        region: 'Americas',
      ),
      Location(
        id: 'dubai-uae',
        name: 'Dubai',
        country: 'United Arab Emirates',
        description: 'Futuristic city with record-breaking architecture, luxury shopping, and desert adventures.',
        imageUrl: 'https://picsum.photos/seed/dubai-burj-khalifa-night-uae/1600/900.jpg',
        latitude: 25.2048,
        longitude: 55.2708,
        timezone: 'Asia/Dubai',
        currency: 'AED',
        language: 'Arabic',
        attractions: ['Burj Khalifa', 'Dubai Mall', 'Palm Jumeirah', 'Dubai Marina'],
        activities: ['Desert Safari', 'Shopping', 'Dune Bashing', 'Skydiving'],
        bestTimeToVisit: 'November - March',
        climate: 'Desert',
        population: 3331000,
        region: 'Asia',
      ),
      Location(
        id: 'rome-italy',
        name: 'Rome',
        country: 'Italy',
        description: 'Eternal City where ancient ruins, Renaissance art, and vibrant street life create an unforgettable experience.',
        imageUrl: 'https://picsum.photos/seed/rome-colosseum-italy-ancient/1600/900.jpg',
        latitude: 41.9028,
        longitude: 12.4964,
        timezone: 'Europe/Rome',
        currency: 'EUR',
        language: 'Italian',
        attractions: ['Colosseum', 'Vatican City', 'Trevi Fountain', 'Roman Forum'],
        activities: ['Historical Tours', 'Gelato Tasting', 'Vatican Museums', 'Food Tours'],
        bestTimeToVisit: 'April - June, September - October',
        climate: 'Mediterranean',
        population: 2873000,
        region: 'Europe',
      ),
      Location(
        id: 'santorini-greece',
        name: 'Santorini',
        country: 'Greece',
        description: 'Stunning sunsets, white-washed buildings, and crystal-clear waters in the Aegean Sea.',
        imageUrl: 'https://picsum.photos/seed/santorini-sunset-greece-island/1600/900.jpg',
        latitude: 36.3932,
        longitude: 25.4615,
        timezone: 'Europe/Athens',
        currency: 'EUR',
        language: 'Greek',
        attractions: ['Oia Sunset', 'Red Beach', 'Akrotiri Archaeological Site', 'Fira Town'],
        activities: ['Wine Tasting', 'Sunset Viewing', 'Beach Hopping', 'Boat Tours'],
        bestTimeToVisit: 'April - October',
        climate: 'Mediterranean',
        population: 15500,
        region: 'Europe',
      ),
    ];

    _locations.addAll(sampleLocations);
  }

  Future<void> _fetchLocationDetails() async {
    // Fetch country data from REST Countries API
    for (var location in _locations) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/name/${location.country}'),
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data.isNotEmpty) {
            final countryData = data[0];
            // Update location with additional country data
            location.currency = countryData['currencies'][0]['code'] ?? location.currency;
            location.language = countryData['languages'][countryData['languages'].keys.first] ?? location.language;
            location.population = countryData['population'] ?? location.population;
          }
        }
      } catch (e) {
        // If API fails, keep the existing data
        print('Failed to fetch details for ${location.country}: $e');
      }
    }
  }

  Location? getLocationById(String id) {
    try {
      return _locations.firstWhere((location) => location.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Location> getLocationsByRegion(String region) {
    return _locations.where((location) => location.region == region).toList();
  }

  List<Location> searchLocations(String query) {
    final lowerQuery = query.toLowerCase();
    return _locations.where((location) =>
        location.name.toLowerCase().contains(lowerQuery) ||
        location.country.toLowerCase().contains(lowerQuery) ||
        location.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<Location?> getLocationByCoordinates(double lat, double lon) async {
    // This would use a reverse geocoding API in a real implementation
    // For now, return the closest location
    Location? closest;
    double minDistance = double.infinity;

    for (var location in _locations) {
      final distance = _calculateDistance(lat, lon, location.latitude, location.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        closest = location;
      }
    }

    return closest;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = 
        (dLat / 2).sin() * (dLat / 2).sin() +
        lat1.toRadians().cos() * lat2.toRadians().cos() *
        (dLon / 2).sin() * (dLon / 2).sin();

    final double c = 2 * a.sqrt().asin2(1 - a, 1).sqrt();

    return earthRadius * c;
  }

  Future<void> addLocation(Location location) async {
    _locations.add(location);
  }

  Future<void> updateLocation(Location location) async {
    final index = _locations.indexWhere((loc) => loc.id == location.id);
    if (index != -1) {
      _locations[index] = location;
    }
  }

  Future<void> deleteLocation(String id) async {
    _locations.removeWhere((location) => location.id == id);
  }
}

extension on double {
  double toRadians() => this * (3.14159265358979323846 / 180);
  double sin() => math.sin(this);
  double cos() => math.cos(this);
  double asin() => math.asin(this);
  double sqrt() => math.sqrt(this);
}

import 'dart:math' as math;
