import 'package:flutter/material.dart';
import '../services/location_api_service.dart';

class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double price;
  final List<String> activities;
  final String category;
  final Color themeColor;
  final List<String> highlights;
  final String bestTimeToVisit;
  final Duration averageStay;
  final Location? locationData;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.activities,
    required this.category,
    required this.themeColor,
    required this.highlights,
    required this.bestTimeToVisit,
    required this.averageStay,
    this.locationData,
  });

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    double? price,
    List<String>? activities,
    String? category,
    Color? themeColor,
    List<String>? highlights,
    String? bestTimeToVisit,
    Duration? averageStay,
    Location? locationData,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      activities: activities ?? this.activities,
      category: category ?? this.category,
      themeColor: themeColor ?? this.themeColor,
      highlights: highlights ?? this.highlights,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      averageStay: averageStay ?? this.averageStay,
      locationData: locationData ?? this.locationData,
    );
  }
}

class ProfessionalDestinations {
  static const List<Destination> popularDestinations = [
    Destination(
      id: 'paris-france',
      name: 'Paris',
      country: 'France',
      description: 'The City of Light awaits with iconic landmarks, world-class museums, and exquisite cuisine.',
      imageUrl: 'https://picsum.photos/seed/paris-eiffel-tower-landmark-cityscape/1600/900.jpg',
      rating: 4.8,
      reviewCount: 15420,
      price: 2500.0,
      activities: ['Eiffel Tower', 'Louvre Museum', 'Seine River Cruise', 'Montmartre'],
      category: 'Cultural',
      themeColor: Color(0xFFE8B4B8),
      highlights: ['Romantic atmosphere', 'Art & Culture', 'Fine Dining', 'Historic landmarks'],
      bestTimeToVisit: 'April - June, September - October',
      averageStay: Duration(days: 4),
    ),
    Destination(
      id: 'tokyo-japan',
      name: 'Tokyo',
      country: 'Japan',
      description: 'A mesmerizing blend of ancient traditions and cutting-edge technology in the world\'s most populous metropolis.',
      imageUrl: 'https://picsum.photos/seed/tokyo-skyline-mt-fuji-japan-urban/1600/900.jpg',
      rating: 4.9,
      reviewCount: 12890,
      price: 3200.0,
      activities: ['Senso-ji Temple', 'Shibuya Crossing', 'Mount Fuji Day Trip', 'Tsukiji Market'],
      category: 'Urban',
      themeColor: Color(0xFFB8E8B8),
      highlights: ['Technology hub', 'Traditional culture', 'Amazing food', 'Efficient transport'],
      bestTimeToVisit: 'March - May, October - November',
      averageStay: Duration(days: 5),
    ),
    Destination(
      id: 'bali-indonesia',
      name: 'Bali',
      country: 'Indonesia',
      description: 'Tropical paradise with stunning beaches, ancient temples, and lush rice terraces.',
      imageUrl: 'https://picsum.photos/seed/bali-tanah-lot-temple-beach-indonesia/1600/900.jpg',
      rating: 4.7,
      reviewCount: 18920,
      price: 1800.0,
      activities: ['Beach surfing', 'Temple tours', 'Rice terrace walks', 'Traditional dance shows'],
      category: 'Beach',
      themeColor: Color(0xFF87CEEB),
      highlights: ['Beautiful beaches', 'Rich culture', 'Affordable luxury', 'Wellness retreats'],
      bestTimeToVisit: 'April - October',
      averageStay: Duration(days: 7),
    ),
    Destination(
      id: 'new-york-usa',
      name: 'New York City',
      country: 'United States',
      description: 'The city that never sleeps offers endless entertainment, world-class museums, and iconic skyline.',
      imageUrl: 'https://picsum.photos/seed/newyork-manhattan-skyline-usa-statue-liberty/1600/900.jpg',
      rating: 4.6,
      reviewCount: 22150,
      price: 3500.0,
      activities: ['Statue of Liberty', 'Central Park', 'Broadway Shows', 'Times Square'],
      category: 'Urban',
      themeColor: Color(0xFFE8E8B8),
      highlights: ['World-class museums', 'Broadway shows', 'Diverse cuisine', 'Iconic landmarks'],
      bestTimeToVisit: 'April - June, September - November',
      averageStay: Duration(days: 5),
    ),
    Destination(
      id: 'dubai-uae',
      name: 'Dubai',
      country: 'United Arab Emirates',
      description: 'Futuristic city with record-breaking architecture, luxury shopping, and desert adventures.',
      imageUrl: 'https://picsum.photos/seed/dubai-burj-khalifa-desert-night-uae-modern/1600/900.jpg',
      rating: 4.8,
      reviewCount: 16780,
      price: 4000.0,
      activities: ['Burj Khalifa', 'Desert Safari', 'Dubai Mall', 'Palm Jumeirah'],
      category: 'Luxury',
      themeColor: Color(0xFFB8B8E8),
      highlights: ['Luxury shopping', 'Modern architecture', 'Desert adventures', 'Fine dining'],
      bestTimeToVisit: 'November - March',
      averageStay: Duration(days: 4),
    ),
    Destination(
      id: 'rome-italy',
      name: 'Rome',
      country: 'Italy',
      description: 'Eternal City where ancient ruins, Renaissance art, and vibrant street life create an unforgettable experience.',
      imageUrl: 'https://picsum.photos/seed/rome-colosseum-vatican-italy-ancient-historic/1600/900.jpg',
      rating: 4.7,
      reviewCount: 19230,
      price: 2200.0,
      activities: ['Colosseum', 'Vatican City', 'Trevi Fountain', 'Roman Forum'],
      category: 'Historical',
      themeColor: Color(0xFFE8B8D8),
      highlights: ['Ancient history', 'Art & Architecture', 'Italian cuisine', 'Romantic atmosphere'],
      bestTimeToVisit: 'April - June, September - October',
      averageStay: Duration(days: 4),
    ),
  ];

  static const List<Destination> trendingDestinations = [
    Destination(
      id: 'santorini-greece',
      name: 'Santorini',
      country: 'Greece',
      description: 'Stunning sunsets, white-washed buildings, and crystal-clear waters in the Aegean Sea.',
      imageUrl: 'https://picsum.photos/seed/santorini-sunset-greece-island/1600/900.jpg',
      rating: 4.9,
      reviewCount: 8760,
      price: 2800.0,
      activities: ['Sunset viewing', 'Wine tasting', 'Beach hopping', 'Volcano tours'],
      category: 'Romantic',
      themeColor: Color(0xFF87CEEB),
      highlights: ['Iconic sunsets', 'Beautiful beaches', 'Greek cuisine', 'Luxury resorts'],
      bestTimeToVisit: 'April - October',
      averageStay: Duration(days: 4),
    ),
    Destination(
      id: 'iceland',
      name: 'Iceland',
      country: 'Iceland',
      description: 'Land of fire and ice with glaciers, geysers, hot springs, and the Northern Lights.',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop',
      rating: 4.8,
      reviewCount: 6540,
      price: 3500.0,
      activities: ['Northern Lights', 'Glacier hiking', 'Blue Lagoon', 'Whale watching'],
      category: 'Adventure',
      themeColor: Color(0xFFB8E8E8),
      highlights: ['Northern Lights', 'Unique landscapes', 'Hot springs', 'Adventure activities'],
      bestTimeToVisit: 'June - August (summer), September - March (Northern Lights)',
      averageStay: Duration(days: 6),
    ),
    Destination(
      id: 'morocco',
      name: 'Morocco',
      country: 'Morocco',
      description: 'Exotic blend of Arab, Berber, and European cultures with vibrant souks and stunning landscapes.',
      imageUrl: 'https://images.unsplash.com/photo-1555212697-194d092e3b8f?w=800&h=600&fit=crop',
      rating: 4.6,
      reviewCount: 7890,
      price: 1900.0,
      activities: ['Marrakech Medina', 'Sahara Desert', 'Fez souks', 'Atlas Mountains'],
      category: 'Cultural',
      themeColor: Color(0xFFE8B8B8),
      highlights: ['Exotic culture', 'Desert adventures', 'Traditional markets', 'Beautiful architecture'],
      bestTimeToVisit: 'March - May, September - November',
      averageStay: Duration(days: 7),
    ),
  ];

  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Adventure',
      'icon': Icons.hiking,
      'color': Color(0xFF48BB78),
      'count': 156,
      'description': 'Thrilling experiences and outdoor adventures',
    },
    {
      'name': 'Cultural',
      'icon': Icons.museum,
      'color': Color(0xFF805AD5),
      'count': 234,
      'description': 'Immerse yourself in local traditions and history',
    },
    {
      'name': 'Beach',
      'icon': Icons.beach_access,
      'color': Color(0xFF4299E1),
      'count': 189,
      'description': 'Relax on pristine beaches and crystal waters',
    },
    {
      'name': 'Urban',
      'icon': Icons.location_city,
      'color': Color(0xFFED8936),
      'count': 298,
      'description': 'Explore vibrant cities and modern life',
    },
    {
      'name': 'Luxury',
      'icon': Icons.diamond,
      'color': Color(0xFFD69E2E),
      'count': 87,
      'description': 'Indulge in premium experiences and comfort',
    },
    {
      'name': 'Romantic',
      'icon': Icons.favorite,
      'color': Color(0xFFE53E3E),
      'count': 145,
      'description': 'Perfect destinations for couples and romance',
    },
  ];

  static const List<Map<String, dynamic>> experiences = [
    {
      'name': 'Northern Lights',
      'icon': Icons.nights_stay,
      'color': Color(0xFF4A5568),
      'count': 45,
      'locations': ['Iceland', 'Norway', 'Finland'],
      'price': '\$2,500',
    },
    {
      'name': 'Safari Adventure',
      'icon': Icons.pets,
      'color': Color(0xFF38B2AC),
      'count': 67,
      'locations': ['Kenya', 'Tanzania', 'South Africa'],
      'price': '\$3,200',
    },
    {
      'name': 'Scuba Diving',
      'icon': Icons.scuba_diving,
      'color': Color(0xFF4299E1),
      'count': 89,
      'locations': ['Great Barrier Reef', 'Maldives', 'Bali'],
      'price': '\$1,800',
    },
    {
      'name': 'Wine Tasting',
      'icon': Icons.wine_bar,
      'color': Color(0xFF9F7AEA),
      'count': 123,
      'locations': ['Napa Valley', 'Bordeaux', 'Tuscany'],
      'price': '\$1,200',
    },
    {
      'name': 'Mountain Hiking',
      'icon': Icons.hiking,
      'color': Color(0xFF48BB78),
      'count': 234,
      'locations': ['Swiss Alps', 'Rocky Mountains', 'Himalayas'],
      'price': '\$800',
    },
    {
      'name': 'Food Tours',
      'icon': Icons.restaurant,
      'color': Color(0xFFE53E3E),
      'count': 298,
      'locations': ['Tokyo', 'Paris', 'Rome', 'Bangkok'],
      'price': '\$600',
    },
  ];
}
