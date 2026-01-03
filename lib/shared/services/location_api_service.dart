import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class Location {
  String id;
  String name;
  String country;
  String description;
  String imageUrl;
  double latitude;
  double longitude;
  String timezone;
  String currency;
  String language;
  List<String> attractions;
  List<String> activities;
  String bestTimeToVisit;
  String climate;
  int population;
  String region;
  String? countryCode;
  String? adminCode;
  String? featureClass;

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
    this.countryCode,
    this.adminCode,
    this.featureClass,
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
      countryCode: json['countryCode'],
      adminCode: json['adminCode'],
      featureClass: json['featureClass'],
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
      'countryCode': countryCode,
      'adminCode': adminCode,
      'featureClass': featureClass,
    };
  }
}

class LocationApiService {
  static final LocationApiService _instance = LocationApiService._internal();
  factory LocationApiService() => _instance;
  LocationApiService._internal();

  final List<Location> _locations = [];
  
  // API Endpoints
  static const String _restCountriesUrl = 'https://restcountries.com/v3.1';
  static const String _geoNamesUrl = 'http://api.geonames.org';
  static const String _openWeatherUrl = 'https://api.openweathermap.org/data/2.5';
  
  // API Keys (you should get these from the respective services)
  static const String _geoNamesUsername = 'demo'; // Replace with your username
  static const String _openWeatherApiKey = 'demo'; // Replace with your API key

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

  // Search for locations worldwide using GeoNames API
  Future<List<Location>> searchWorldwideLocations(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_geoNamesUrl/search?q=$query&maxRows=10&username=$_geoNamesUsername'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final geonames = data['geonames'] as List;
        
        return geonames.map((geoname) => Location(
          id: '${geoname['name']}-${geoname['countryCode']}'.toLowerCase().replaceAll(' ', '-'),
          name: geoname['name'] ?? '',
          country: geoname['countryName'] ?? '',
          description: 'Location found via GeoNames API',
          imageUrl: 'https://picsum.photos/seed/${geoname['name']}-${geoname['countryCode']}/1600/900.jpg',
          latitude: double.tryParse(geoname['lat']?.toString() ?? '0') ?? 0.0,
          longitude: double.tryParse(geoname['lng']?.toString() ?? '0') ?? 0.0,
          timezone: 'UTC', // Will be updated later
          currency: 'USD', // Will be updated later
          language: 'English', // Will be updated later
          attractions: [],
          activities: [],
          bestTimeToVisit: 'Year-round',
          climate: 'Temperate', // Will be updated later
          population: int.tryParse(geoname['population']?.toString() ?? '0') ?? 0,
          region: _getRegionFromCountryCode(geoname['countryCode']),
          countryCode: geoname['countryCode'],
          adminCode: geoname['adminCode1'],
          featureClass: geoname['fcl'],
        )).toList();
      }
    } catch (e) {
      print('Error searching worldwide locations: $e');
    }
    
    return [];
  }

  // Get weather and timezone data for a location
  Future<void> enrichLocationWithWeather(Location location) async {
    try {
      // Get weather data (includes timezone info)
      final weatherResponse = await http.get(
        Uri.parse('$_openWeatherUrl/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$_openWeatherApiKey&units=metric'),
      ).timeout(const Duration(seconds: 5));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        
        // Update climate based on weather data
        if (weatherData['main'] != null) {
          final temp = weatherData['main']['temp'] ?? 20;
          location.climate = _getClimateFromTemperature(temp);
        }
        
        // Update timezone if available
        if (weatherData['timezone'] != null) {
          location.timezone = _getTimezoneFromOffset(weatherData['timezone']);
        }
      }
    } catch (e) {
      print('Error enriching location with weather: $e');
    }
  }

  // Get detailed country information
  Future<void> enrichLocationWithCountryData(Location location) async {
    try {
      final response = await http.get(
        Uri.parse('$_restCountriesUrl/name/${location.country}'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final countryData = data[0];
          
          // Update location with country data
          location.currency = countryData['currencies'][0]['code'] ?? location.currency;
          location.language = countryData['languages'][countryData['languages'].keys.first] ?? location.language;
          location.population = countryData['population'] ?? location.population;
          location.countryCode = countryData['cca2'];
          
          // Add country-specific attractions and activities
          location.attractions = _getCountryAttractions(location.countryCode);
          location.activities = _getCountryActivities(location.countryCode);
          location.bestTimeToVisit = _getBestTimeToVisit(location.countryCode);
        }
      }
    } catch (e) {
      print('Error enriching location with country data: $e');
    }
  }

  String _getRegionFromCountryCode(String? countryCode) {
    if (countryCode == null) return 'Unknown';
    
    final Map<String, String> regionMap = {
      'US': 'Americas',
      'CA': 'Americas',
      'MX': 'Americas',
      'BR': 'Americas',
      'AR': 'Americas',
      'GB': 'Europe',
      'FR': 'Europe',
      'DE': 'Europe',
      'IT': 'Europe',
      'ES': 'Europe',
      'NL': 'Europe',
      'JP': 'Asia',
      'CN': 'Asia',
      'IN': 'Asia',
      'KR': 'Asia',
      'TH': 'Asia',
      'ID': 'Asia',
      'AU': 'Oceania',
      'NZ': 'Oceania',
      'ZA': 'Africa',
      'EG': 'Africa',
      'KE': 'Africa',
      'MA': 'Africa',
    };
    
    return regionMap[countryCode] ?? 'Unknown';
  }

  String _getClimateFromTemperature(double temp) {
    if (temp < 0) return 'Arctic';
    if (temp < 10) return 'Cold';
    if (temp < 20) return 'Temperate';
    if (temp < 30) return 'Warm';
    return 'Tropical';
  }

  String _getTimezoneFromOffset(int offset) {
    final hours = offset ~/ 3600;
    final sign = hours >= 0 ? '+' : '-';
    return 'UTC$sign${hours.abs()}';
  }

  List<String> _getCountryAttractions(String? countryCode) {
    final Map<String, List<String>> attractions = {
      'FR': ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame', 'Arc de Triomphe'],
      'JP': ['Tokyo Skytree', 'Senso-ji Temple', 'Mount Fuji', 'Tokyo Tower'],
      'ID': ['Tanah Lot Temple', 'Ubud Rice Terraces', 'Mount Batur', 'Uluwatu Temple'],
      'US': ['Statue of Liberty', 'Central Park', 'Empire State Building', 'Times Square'],
      'AE': ['Burj Khalifa', 'Dubai Mall', 'Palm Jumeirah', 'Dubai Marina'],
      'IT': ['Colosseum', 'Vatican City', 'Trevi Fountain', 'Roman Forum'],
      'GR': ['Oia Sunset', 'Red Beach', 'Akrotiri', 'Fira Town'],
    };
    
    return attractions[countryCode] ?? ['Local attractions', 'Historic sites', 'Natural wonders', 'Cultural centers'];
  }

  List<String> _getCountryActivities(String? countryCode) {
    final Map<String, List<String>> activities = {
      'FR': ['River Seine Cruise', 'Museum Tours', 'Wine Tasting', 'Shopping'],
      'JP': ['Sushi Making', 'Karaoke', 'Shopping', 'Cherry Blossom Viewing'],
      'ID': ['Surfing', 'Temple Tours', 'Yoga Retreats', 'Traditional Dance'],
      'US': ['Broadway Shows', 'Museum Visits', 'Shopping', 'Food Tours'],
      'AE': ['Desert Safari', 'Shopping', 'Dune Bashing', 'Skydiving'],
      'IT': ['Historical Tours', 'Gelato Tasting', 'Vatican Museums', 'Food Tours'],
      'GR': ['Wine Tasting', 'Sunset Viewing', 'Beach Hopping', 'Boat Tours'],
    };
    
    return activities[countryCode] ?? ['Sightseeing', 'Local cuisine', 'Cultural experiences', 'Outdoor activities'];
  }

  String _getBestTimeToVisit(String? countryCode) {
    final Map<String, String> bestTime = {
      'FR': 'April - June, September - October',
      'JP': 'March - May, October - November',
      'ID': 'April - October',
      'US': 'April - June, September - November',
      'AE': 'November - March',
      'IT': 'April - June, September - October',
      'GR': 'April - October',
    };
    
    return bestTime[countryCode] ?? 'Year-round';
  }

  Future<void> _addSampleLocations() async {
    final sampleLocations = [
      Location(
        id: 'paris-france',
        name: 'Paris',
        country: 'France',
        description: 'The City of Light is renowned for its art, fashion, gastronomy, and culture. Home to iconic landmarks like the Eiffel Tower and Louvre Museum.',
        imageUrl: 'https://picsum.photos/seed/paris-eiffel-tower-landmark-cityscape/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/tokyo-skyline-mt-fuji-japan-urban/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/bali-tanah-lot-temple-beach-indonesia/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/newyork-manhattan-skyline-usa-statue-liberty/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/dubai-burj-khalifa-desert-night-uae-modern/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/rome-colosseum-vatican-italy-ancient-historic/1600/900.jpg',
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
        imageUrl: 'https://picsum.photos/seed/santorini-sunset-oia-village-greece-island/1600/900.jpg',
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
    // Fetch country data and enrich locations from APIs
    for (var location in _locations) {
      try {
        // Enrich with country data
        await enrichLocationWithCountryData(location);
        
        // Enrich with weather data
        await enrichLocationWithWeather(location);
        
        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 100));
        
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
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.14159265358979323846 / 180);
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

  // Get API setup instructions
  static Map<String, String> getApiSetupInstructions() {
    return {
      'GeoNames': '1. Register at http://www.geonames.org/login\n2. Get your free username\n3. Replace _geoNamesUsername with your username',
      'OpenWeatherMap': '1. Sign up at https://openweathermap.org/api\n2. Get free API key (1000 calls/day)\n3. Replace _openWeatherApiKey with your key',
      'REST Countries': 'No API key required - completely free',
      'Mapbox': '1. Sign up at https://www.mapbox.com/\n2. Get free API key (100,000 requests/month)\n3. Add to your app for enhanced geocoding',
      'Google Places': '1. Enable Google Places API in Google Cloud Console\n2. Get API key with \$300 monthly credit\n3. Add for most comprehensive location data',
    };
  }

  // Check if APIs are properly configured
  Map<String, bool> checkApiConfiguration() {
    return {
      'geoNamesConfigured': _geoNamesUsername != 'demo',
      'openWeatherConfigured': _openWeatherApiKey != 'demo',
      'restCountriesAvailable': true, // Always available
    };
  }

  // Get current API limits
  Map<String, String> getApiLimits() {
    return {
      'GeoNames': 'Free: 2000 requests/hour after registration',
      'OpenWeatherMap': 'Free: 1000 calls/day, 60 calls/minute',
      'REST Countries': 'Free: No limits',
      'Mapbox': 'Free: 100,000 requests/month',
      'Google Places': 'Free: \$300 monthly credit (~3000 requests)',
    };
  }
}

extension on double {
  double toRadians() => this * (3.14159265358979323846 / 180);
  double sin() => math.sin(this);
  double cos() => math.cos(this);
  double asin() => math.asin(this);
  double sqrt() => math.sqrt(this);
}
